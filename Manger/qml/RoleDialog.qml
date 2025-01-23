import QtQuick
import QtQuick.Controls

MyPopup{
    id:myPopup
    property alias roleNameText: roleName.text//name文本框内容
    property alias roleIconText: roleIcon.pathStr//icon文本框内容
    Column{
        parent: myPopup.column
        anchors.top: parent.top
        anchors.topMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 5
        Label{
            id:roleNameLabel
            text: qsTr("Role Name:")
            height: 25
            font.pixelSize: 16
        }
        CustInputText{//输入Rolename框
            id:roleName
            width: myPopup.column.width-20
            height: 30
            placeholderText: qsTr("Role Name")
        }
        Label{
            id:roleIconLabel
            text: qsTr("Icon Path:")
            height: 25
            font.pixelSize: 16
        }
        CustInputIconPath{//选择或输入icon path的框
            id:roleIcon
            width: myPopup.column.width-20
            height: 30
            phText: qsTr("Icon Path")
        }
    }
    onClosed: {
        roleIcon.pathStr=""
        roleName.text=""
    }
}
