import QtQuick
import QtQuick.Controls

Popup{
    //暴露的属性的别名
    property alias confirmation: confirmation//把确认按钮给暴露出来
    property alias cancel: cancel//把取消按钮暴露出来
    property alias column:column
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
            id:column
            anchors.fill: parent
            topPadding: 7
            spacing: 10
            Row{//ann
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 30
                anchors.left: parent.left
                anchors.right: parent.right
                padding: 30
                MyButton{//提交按钮
                    id:confirmation
                    text: qsTr("Confirmation")
                    anchors.left: parent.left
                    anchors.leftMargin: 40
                    anchors.verticalCenter:parent.verticalCenter
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
                    anchors.verticalCenter:parent.verticalCenter
                    onClicked: {
                        root.close()
                    }
                }
            }
        }
    }
}
