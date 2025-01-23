import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import GameModel


Popup{
    //暴露的属性的别名
    property alias cdName: cdName.text//name输入框的文本
    property alias cdPath: cdPath.pathStr//path输入框的文本
    property alias cdIcon: cdIcon.pathStr//icon输入框的文本
    property alias confirmation: confirmation//把确认按钮给暴露出来
    property alias cancel: cancel//把取消按钮暴露出来
    id:root
    width: 480
    height: 320
    dim:true//背景变暗
    modal: true
    anchors.centerIn: parent
    parent: Overlay.overlay
    background: Rectangle{
        id:dlbg
        anchors.fill: parent
        color: "#E0E7F6"
        radius: 9
    }
    //打开和关闭的动画
    enter: Transition {
        NumberAnimation { property: "scale"; from: 0.5; to: 1.0; duration: 150 }
        NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration:150 }
    }
    exit: Transition {
        NumberAnimation { property: "scale"; from: 1.0; to: 0.5; duration: 150 }
        NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 150 }
    }
    Rectangle{
        id:content
        anchors.fill: parent
        anchors.topMargin: 30
        anchors.rightMargin: 3
        anchors.leftMargin: 3
        anchors.bottomMargin: 3
        color: "white"
        radius: dlbg.radius
        Column{
            topPadding: 7
            spacing: 10
            anchors.horizontalCenter: parent.horizontalCenter
            clip: true
            Label{
                id:nameLabel
                text: qsTr("Game Name:")
                height: 10
                font.pixelSize: 16
                // anchors.left: parent.left
                // anchors.leftMargin: 10
            }
            CustInputText{//输入name框
                id:cdName
                width: content.width-30
                height: 30
                // anchors.horizontalCenter: parent.horizontalCenter
                placeholderText: "Game Name"
            }
            Label{
                id:pathLabel
                text: qsTr("Path:")
                height: 10
                font.pixelSize: 16
                // anchors.left: parent.left
                // anchors.leftMargin: 10
            }
            CustInputFilePath{//选择或输入path的框
                id:cdPath
                width: content.width-30
                height: 30
                // anchors.horizontalCenter: parent.horizontalCenter
            }
            Label{
                id:iconLabel
                text: qsTr("Icon Path:")
                height: 10
                font.pixelSize: 16
                // anchors.left: parent.left
                // anchors.leftMargin: 10
            }
            CustInputIconPath{//选择或输入icon path的框
                id:cdIcon
                width: content.width-30
                height: 30
                // anchors.horizontalCenter: parent.horizontalCenter
                phText: "Icon Path"
            }
            Item{
                height: 60
                width: parent.width
                MyButton{//提交按钮
                    id:confirmation
                    text: qsTr("Confirmation")
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    onClicked: {
                        // GameModel.addGame(cdName.text, cdPath.pathStr, cdIcon.pathStr)
                        // //清除输入框里面的内容
                        // cdName.text=""
                        // cdPath.pathStr=""
                        // cdIcon.pathStr=""
                        // root.close()
                    }
                }
                MyButton{//取消按钮
                    id:cancel
                    text: qsTr("Cancel")
                    anchors.right: parent.right
                    anchors.rightMargin: 40
                    anchors.top: parent.top
                    anchors.topMargin: 30
                    onClicked: {
                        root.close()
                    }
                }
            }
        }
    }
    onClosed: {
        //弹出窗口消失时清除输入框
        cdName.text=""
        cdPath.pathStr=""
        cdIcon.pathStr=""
    }
}

