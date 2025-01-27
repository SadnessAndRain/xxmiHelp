import QtQuick
import QtQuick.Controls
import GameModel
import QtQuick.Layouts
import RoleModel
import ModModel

Rectangle{
    //把ListView暴路出来
    property alias listView: listView
    //当前所选game行的id
    property int currentGameIndex :-1
    //当前的目标路径
    property string currentTargetPath
    //当前game的name
    property string currentGameName
    //暴露出buttonGroup
    property alias buttonGroup: buttonGroup
    id:rect
    width: 170
    height: parent.height
    radius: 9
    clip:true//裁剪
    ListView {//列表视图
        id:listView
        clip:true
        property int currentId: -1
        anchors.fill: parent
        // spacing: 10
        // header:Rectangle{
        //     id:listName
        //     height: 50
        //     width: rect.width
        //     color: "green"
        //     Text {
        //         anchors.centerIn: parent
        //         text: "G"
        //         font.pixelSize: 20 // 设置字体大小
        //         color: "white" // 设置字体颜色
        //     }
        // }
        model:  GameModel//模型
        ButtonGroup { id: buttonGroup }// 按钮互斥组，控制只能选中一个
        //修改窗口
        CustomDialog{
            id:customDialog
            Connections{
                target: customDialog.confirmation
                function onClicked(){
                    GameModel.modifyGame(listView.currentId,customDialog.cdName, customDialog.cdPath, customDialog.cdIcon)
                    //清除输入框里面的内容
                    customDialog.cdName=""
                    customDialog.cdPath=""
                    customDialog.cdIcon=""
                    customDialog.close()
                }
            }
        }
        //高亮部分
        highlight:Rectangle{
            id:hlRect
            color: "#F8FAFD"
            width: 10
            radius: 9
        }
        highlightMoveDuration:150
        //委托组件
        delegate: RoundButton {
            id:roundBtn
            width: rect.width
            height: 40
            text: name
            radius: 9
            autoExclusive: true//启用排他
            checkable: true//可选中
            background: Rectangle {
                id:bg
                anchors.top: parent.top
                anchors.topMargin: 5
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 5
                width: 150
                anchors.horizontalCenter: parent.horizontalCenter
                color:  roundBtn.hovered ? "#F5F8FD" : "transparent"// 选中时变成绿色，未选中时变成灰色
                radius: parent.radius
                border.color: "transparent" // 去掉边框
            }
            //弹出的菜单栏
            MyMenu{
                id:myMenu
                onClicked: {//设置当前id
                    // listView.currentIndex=id
                    listView.currentId=id
                }
                //menu的delete逻辑部分
                Connections{
                    target: myMenu.delelt
                    function onTriggered(){
                        GameModel.deleteGame(id)
                        RoleModel.clearData()
                        ModModel.clearData()
                    }
                }
                //menu的modify逻辑部分
                Connections{
                    target: myMenu.modify
                    function onTriggered(){
                        customDialog.open()
                        customDialog.cdName=name
                        customDialog.cdPath=path
                        customDialog.cdIcon=model.icon
                    }
                }
            }

            ButtonGroup.group: buttonGroup // 关键：将按钮绑定到互斥组
            //当点击game列表的按钮后重新加载roleList的数据
            onClicked: {
                RoleModel.reloadData(id)
                currentGameIndex=id
                currentTargetPath=path
                currentGameName=name
                listView.currentIndex=index
            }
        }
        Component.onCompleted: {
            listView.currentIndex=-1
        }
    }
}


