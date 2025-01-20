import QtQuick
import QtQuick.Controls
import Qt5Compat.GraphicalEffects
import GameModel
import RoleModel
import ModModel
// import ModModel

Window {
    id: root
    width: 970
    minimumWidth:970
    height: 720
    visible: true
    title: qsTr("Hello World")

    color: "transparent"
    flags: Qt.Window |Qt.FramelessWindowHint


    property int bw: 4

    //拖动所需自定义属性,以使用其他方法
    // property int dragX: 0
    // property int dragY: 0
    // property bool dragging: false

    //设置窗口缩放动画
    Behavior on width{
        NumberAnimation{
            duration: 2500
            easing.type: Easing.InOutQuad // 动画缓动类型
        }
    }
    Behavior on height{
        NumberAnimation{
            duration: 2500
            easing.type: Easing.InOutQuad // 动画缓动类型
        }
    }


    //内容
    Rectangle
    {
        id:main
        anchors.fill: parent
        // gradient: Gradient
        // {
        //     GradientStop{ position: 0.0; color:"#1f005c"}
        //     GradientStop{ position: 1.0; color:"#ffb56b"}
        // }
        color: "#E0E7F6"
        radius: 9

        // 鼠标区域仅用于设置正确的光标形状
        MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            cursorShape: {
                const p = Qt.point(mouseX, mouseY);
                const b = bw ; // 稍微增加角的大小
                if (p.x <= b && p.y <= b) return Qt.SizeFDiagCursor;//↘光标
                if (p.x >= width - b && p.y >= height - b) return Qt.SizeFDiagCursor;//↘光标
                if (p.x >= width - b && p.y <= b) return Qt.SizeBDiagCursor;//↗光标
                if (p.x <= b && p.y >= height - b) return Qt.SizeBDiagCursor;//↗光标
                if (p.x < b || p.x > width - b) return Qt.SizeHorCursor;//↔光标
                if (p.y < b || p.y > height - b) return Qt.SizeVerCursor;//↕光标
            }
            acceptedButtons: Qt.NoButton // 不要处理实际事件
        }

        //缩放实现
        DragHandler {
            id: resizeHandler
            grabPermissions: TapHandler.CanTakeOverFromAnything// 允许 DragHandler 接管任何控件的拖动
            target: null// DragHandler 不控制特定目标，监听整个窗口
            onActiveChanged: if (active) {
                const p = resizeHandler.centroid.position;
                const b = bw + 11; // 稍微增加角的大小
                let e = 0;
                if (p.x <= b) { e |= Qt.LeftEdge }
                if (p.x >= width - b) { e |= Qt.RightEdge }
                if (p.y <= b) { e |= Qt.TopEdge }
                if (p.y >= height - b) { e |= Qt.BottomEdge }
                console.log(e)
                root.startSystemResize(e);
            }
        }

        // 标题栏
        Rectangle
        {
            id:titleBar
            width: parent.width-2*bw
            height: 30
            color: parent.color
            // anchors.top: parent.top
            radius: parent.radius
            x:bw
            y:bw
            z:1
            //拖动部分,已停用改为使用DragHandler
            // MouseArea
            // {
            //     anchors.fill: parent
            //     onPressed:
            //     {
            //         root.dragX = mouseX
            //         root.dragY = mouseY
            //         root.dragging = true
            //     }
            //     onReleased: root.dragging = false
            //     onPositionChanged:
            //     {
            //         if(root.dragging)
            //         {
            //             root.x += mouseX - root.dragX
            //             root.y += mouseY - root.dragY
            //         }
            //     }
            // }

            //拖动和双击放大缩小部分
            Item {
                anchors.fill: parent
                TapHandler {
                    onTapped: {
                        if (tapCount === 2) // 如果检测到双击操作，则切换窗口的最大化/恢复状态
                        {
                            if (root.visibility === Window.Maximized) {
                                root.showNormal();
                            } else {
                                root.showMaximized();
                            }
                        }
                    }
                    gesturePolicy: TapHandler.DragThreshold//// 允许轻微的拖动手势，但主要用于双击检测
                }
                DragHandler {
                    target: null
                    grabPermissions: TapHandler.CanTakeOverFromAnything// 允许 DragHandler 接管任何控件的拖动
                    onActiveChanged: if (active) { root.startSystemMove(); }
                }
            }

            Text {
                text: "Manger"
                color: "white"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                font.pixelSize: 18
            }
            // 关闭按钮
            Button {
                id:exitBtn
                text: "✕"
                width: 30
                anchors.right: parent.right      
                anchors.verticalCenter: parent.verticalCenter
                anchors.margins: 5
                background: Rectangle {
                    color: exitBtn.hovered ? "red":"transparent"
                }
                onClicked: Qt.quit()
            }

            // 最小化按钮
            Button {
                id:miniBtn
                text: "🗕"
                width: 30
                anchors.right: exitBtn.left
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: root.showMinimized()
            }

            // 最大化/还原按钮
            Button {
                id:maxBtn
                width: 30
                hoverEnabled: true
                text: root.visibility === Window.Maximized ? "🗗" : "🗖"
                anchors.right: miniBtn.left
                anchors.verticalCenter: parent.verticalCenter
                background: Rectangle {
                    color: "transparent"
                }
                onClicked: {
                    if (root.visibility === Window.Maximized) {
                        root.showNormal();
                    } else {
                        root.showMaximized();
                    }
                }
            }
        }
        //game列
        Column{
            id:gameListColumn
            // anchors.fill: parent
            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.topMargin:titleBar.height
            anchors.left:parent.left
            anchors.leftMargin: bw
            //添加game的按钮
            AddButton{
                id:addBtn
                z:1
                anchors.top: parent.top
                anchors.topMargin: 6
                radius: main.radius
                onClicked: {
                    ctDl.open()
                }
            }
            //game列表
            GameList{
                id:gameList
                color:main.color
                anchors.top: addBtn.bottom
                anchors.topMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 10
                onCurrentGameIndexChanged: {
                    roleAddBtn.visible=true
                    // roleList.currentGameIndex=currentGameIndex//让rolelist的currentGameIndex等于gameList的当前所处index
                    // modGrid.currentTargetPath=gameList.currentTargetPath//告知modGrid当前的目标路径
                    // modGrid.currentGameName=gameList.currentGameName//告知modGrid当前的gameName(史山变多了)
                }
                //buttonGroup中的按钮被选中时
                Connections{
                    target: gameList.buttonGroup
                    function onClicked(){
                        modGrid.currentTargetPath=gameList.currentTargetPath//告知modGrid当前的目标路径
                        modGrid.currentGameName=gameList.currentGameName//告知modGrid当前的gameName(史山变多了)
                        modGrid.currentGameIndex=gameList.currentGameIndex//告知modGrid当前的gameIndex
                        roleList.currentGameIndex=gameList.currentGameIndex//让rolelist的currentGameIndex等于gameList的当前所处index
                        ModModel.clearData()//切换game时清空modGrid
                        modBg.visible=false//顺便直接把modGrid这个视图部分直接隐藏
                    }
                }
            }
        }
        // 中心内容区域
        Rectangle {
            id:content
            color: "#FCFCFC"
            anchors.fill: parent
            anchors.topMargin: titleBar.height+titleBar.y// 预留出标题栏的空间
            anchors.leftMargin: 180
            anchors.bottomMargin: 5
            anchors.rightMargin: 5
            radius: parent.radius // 确保内容区域也有圆角
            //role列表
            Rectangle{
                id:roleBg
                color:"#f5f6f7"
                width: 268
                radius:parent.radius
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                AddButton{//role添加的按钮
                    id:roleAddBtn
                    z:1
                    width: parent.width-8
                    anchors.top: parent.top
                    anchors.horizontalCenter: parent.horizontalCenter
                    visible: false
                    onClicked: {
                        roleDialog.open()
                    }
                }
                //RoleList的背景
                Rectangle{
                    id:roleListBg
                    anchors.fill: parent
                    anchors.top: parent.top
                    color: parent.color
                    clip: true
                    radius: parent.radius
                    RoleList{
                        id:roleList
                        anchors.topMargin: roleAddBtn.height
                        //监听game的currentGameIndex
                        // Connections{
                        //     target: gameList
                        //     function onCurrentGameIndex(){
                        //         roleList.currentGameIndex=gameList.currentGameIndex
                        //     }
                        // }
                        // 实现点击时出现mod的网格视图
                        onCurrentRoleIndexChanged:{
                            modBg.visible=true
                            // modGrid.currentGameIndex=roleList.currentGameIndex
                            // modGrid.currentRoleIndex=roleList.currentRoleIndex//更改ModGrid的当前的roleIndex
                        }
                        //RoleList的buttonGroup中的按钮选中时的处理
                        Connections{
                            target: roleList.roleButtonGroup
                            function onClicked(){
                                modGrid.currentRoleIndex=roleList.currentRoleIndex//更改ModGrid的当前的roleIndex
                                modBg.visible=true//感觉上面的自定义属性的型号处理器有点问题,这里再一次进行显示
                            }
                        }
                    }
                }
            }
            //mod网格
            Rectangle{
                id:modBg
                visible: false
                anchors.fill: parent
                anchors.leftMargin: roleBg.width
                radius: parent.radius
                // color: "#f9fafa"
                clip:true// 裁剪内容
                //mod网格视图部分
                ModGrid{
                    id:modGrid
                }
            }
        }
    }
    //添加game列表的弹出窗口
    CustomDialog{
        id:ctDl
        //确认按钮的操作
        Connections{
            target: ctDl.confirmation
            function onClicked(){
                GameModel.addGame(ctDl.cdName, ctDl.cdPath, ctDl.cdIcon)
                ctDl.close()
            }
        }
    }
    //添加role列表的弹出窗口
    RoleDialog{
        id:roleDialog
        //确认按钮的操作
        Connections{
            target: roleDialog.confirmation
            function onClicked(){
                RoleModel.addRole(roleDialog.roleNameText,roleDialog.roleIconText,gameList.currentGameIndex)
                roleDialog.close()
            }
        }
    }
}
