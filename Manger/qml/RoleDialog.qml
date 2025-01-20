import QtQuick
import QtQuick.Controls

MyPopup{
    id:myPopup
    property alias roleNameText: roleName.text//name文本框内容
    property alias roleIconText: roleIcon.pathStr//icon文本框内容

    CustInputIconPath{//选择或输入icon path的框
        id:roleIcon
        parent: myPopup.column
        width: parent.width-30
        height: 30
        anchors.horizontalCenter: parent.horizontalCenter
        phText: qsTr("Icon Path")
    }
    Label{
        id:roleIconLabel
        parent: myPopup.column
        text: qsTr("Icon Path:")
        height: 10
        font.pixelSize: 16
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    CustInputText{//输入Rolename框
        id:roleName
        parent: myPopup.column
        width: parent.width-30
        height: 30
        anchors.horizontalCenter: parent.horizontalCenter
        placeholderText: qsTr("Role Name")
    }
    Label{
        id:roleNameLabel
        parent: myPopup.column
        text: qsTr("Role Name:")
        height: 10
        font.pixelSize: 16
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    onClosed: {
        roleIcon.pathStr=""
        roleName.text=""
    }
}
