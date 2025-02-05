import QtQuick
import QtQuick.Controls
import ModModel
import QtQuick.Controls.Basic//用来设置主题,方便控件自定义,不然会报错

GridView{
    id:gridView
    property int currentGameIndex:-1//当前game的行的id
    property int currentRoleIndex:-1//当前Role的行的id
    property int currentModIndex:-1//当前Mod的行索引
    property string fileUrl//文件url
    property string imageUrl//图片url
    property string currentTargetPath//当前game的path
    property string currentGameName//当前game的name
    anchors.fill: parent
    model: ModModel
    cellHeight: 270
    cellWidth: 170
    flow:GridView.FlowLeftToRight
    //添加时出现的弹窗
    ModDialog{
        id:addModDialog
        // cancel.visible: false//隐藏关闭按钮
        // closePolicy: Popup.NoAutoClose//设置取消自动关闭
        property bool warning: true//false为出错,true为正常
        //警告弹窗
        WarningPopup{
            id:warningPopup
            title: qsTr("Warning")
            text: qsTr("Same file already exists, please check if the same mod exists.")
            Connections{
                target:warningPopup.confirmation
                function onClicked(){
                    warningPopup.close()
                }
            }
        }
        Connections{
            target: addModDialog.confirmation
            function onClicked(){
                addModDialog.warning=ModModel.addMod(fileUrl, addModDialog.modNameText, addModDialog.modIconText, currentGameName, currentGameIndex, currentRoleIndex, addModDialog.modDescriptionText)
                addModDialog.close()
                //刷新数据
                ModModel.reloadData(currentGameIndex,currentRoleIndex)
                if(addModDialog.warning===false)
                {
                    warningPopup.open()
                }
            }
        }
    }
    //修改时出现的弹窗
    ModDialog{
        id:modifyModDialog
        Connections{//确认按钮进行修改
            target: modifyModDialog.confirmation
            function onClicked(){
                ModModel.modifyMod(gridView.currentIndex, modifyModDialog.modNameText, modifyModDialog.modIconText, modifyModDialog.modDescriptionText)
                modifyModDialog.close()
            }
        }
    }

    //拖入mod来添加部分
    header: AddButton{
        width: parent.width
        height: cellHeight/2
        //拖动区域
        DropArea{
            id:dropArea
            anchors.fill: parent
            enabled: true
            onEntered: function(drag){
                parent.background.color="#e4e6e7"
                if (drag.urls.length !== 1) { // 过滤事件，只能拖拽一个项目
                    drag.accepted = false
                    return false;
                }
            }
            onExited: parent.background.color="#F5F8FD"
            onDropped: function(drop){//当拖动放下时
                console.log(drop.text)
                fileUrl=drop.text
                // ModModel.addMod(drop.text)
                //拖入松开后改变颜色
                parent.background.color="#F5F8FD"
                addModDialog.open()
            }
        }
    }
    //视图过渡
    // add:Transition {
    //     NumberAnimation{
    //         property: "opacity"
    //         from: 0
    //         to:1
    //         duration: 150
    //     }
    //     NumberAnimation{
    //         property: "scale"
    //         from: 0
    //         to:1
    //         duration: 150
    //     }
    // }
    // remove:Transition {
    //     NumberAnimation{
    //         property: "opacity"
    //         from: 1
    //         to:0
    //         duration: 2000
    //     }
    //     NumberAnimation{
    //         property: "scale"
    //         from: 1
    //         to:0
    //         duration: 2000
    //     }
    // }

    //委托部分
    delegate:Component{
        ModBtn{
            id:modBtn
            width: cellWidth
            height: cellHeight
            //图片
            Image {//图片
                id: image
                fillMode: Image.PreserveAspectFit
                source: model.icon? "file:///"+model.icon : "./image/add.png"
                height: parent.height-85
                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.topMargin: 4+10
                anchors.leftMargin: 4+10
                anchors.rightMargin: 4+10
                //拖动放下区域
                DropArea{
                    id:dropArea
                    anchors.fill: parent
                    enabled: true
                    onEntered: function(drag){
                        modBtn.background.color="#e4e6e7"
                        if (drag.urls.length !== 1) { // 过滤事件，只能拖拽一个项目
                            drag.accepted = false
                            return false;
                        }
                    }
                    onExited: modBtn.background.color="#f5f6f7"
                    onDropped: function(drop){//当拖动放下时
                        imageUrl=drop.text
                        //拖入松开后改变颜色
                        modBtn.background.color="#f5f6f7"
                        //添加图片
                        ModModel.addModIcon(currentGameName, id, imageUrl)
                    }
                }
            }
            //右键弹出的菜单栏
            MyMenu{
                id:myMenu
                onClicked: {//设置当前索引
                    gridView.currentIndex=index
                }
            }
            //mod的名称
            Text{
                id:modName
                text: name
                width: parent.width-30
                height: 25
                anchors.top: image.bottom
                anchors.topMargin: 3
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 16
                color: "black"
                horizontalAlignment:Text.AlignHCenter
            }
            //打开mod文件夹的按钮
            MyButton{
                id:openModFile
                width: 60
                height: 24
                anchors.left: modBtn.left
                anchors.leftMargin: 20
                anchors.top: modName.bottom
                anchors.topMargin: 3
                text: qsTr("location")
                onClicked: {
                    ModModel.openModFolder(gridView.currentGameName, fileName, gridView.currentTargetPath, enable)
                }
            }

            //启用的switch按钮
            Switch{
                z:1
                id:switchBtn
                width: 55
                height: 24
                anchors.top: modName.bottom
                anchors.topMargin: 3
                anchors.right: modBtn.right
                anchors.rightMargin: 20
                //设置checked状态
                checked:model.enable===1? true:false
                // //设置样式
                // Material.theme: Material.Dark // 可选: Material.Light 或 Material.Dark
                indicator: Rectangle{//指示器
                    anchors.fill: parent
                    radius: 13
                    color: switchBtn.checked ? "#e2ebf5" : "#c94f4f"
                    border.color: switchBtn.checked ? "#cccccc" : "#cccccc"

                    Rectangle {
                        x: switchBtn.checked ? parent.width - width-3 : 0+3
                        anchors.verticalCenter: parent.verticalCenter
                        width: 20
                        height: 20
                        radius: 11
                        color: switchBtn.hovered ? "#ffffff":(switchBtn.down ? "#ffffff" : "#f5f6f7")
                        border.color: switchBtn.checked ? (switchBtn.down ? "#cccccc" : "#999999") : "#999999"

                        //添加移动动画
                        Behavior on x{
                            NumberAnimation {
                                duration: 150 // 动画时长 (毫秒)
                                easing.type: Easing.InOutQuad // 缓动类型
                            }
                        }
                    }
                    //添加颜色过渡动画
                    Behavior on color {
                        ColorAnimation {
                            duration: 200 // 动画持续时间（毫秒）
                            easing.type: Easing.InOutQuad // 动画缓动类型
                        }
                    }
                }
                //点击时的处理
                onClicked: {
                    //设置当前index
                    gridView.currentIndex=index
                    ModModel.enableMod(gridView.currentIndex, currentGameName, currentTargetPath)
                }
            }



            //menu的delete逻辑部分
            Connections{
                target: myMenu.delelt
                function onTriggered(){
                    ModModel.deleteMod(gridView.currentIndex,currentGameName,currentTargetPath)
                }
            }
            //menu的modify逻辑部分
            Connections{
                target: myMenu.modify
                function onTriggered(){
                    modifyModDialog.open()
                    modifyModDialog.modNameText=name
                    modifyModDialog.modIconText=model.icon
                    modifyModDialog.modDescriptionText=model.description
                }
            }
        }
    }
}

