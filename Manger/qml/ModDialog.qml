import QtQuick
import QtQuick.Controls
MyPopup{
    id:myPopup
    property alias modNameText: modName.text//name文本框内容
    property alias modIconText: modIcon.pathStr//icon文本框内容
    property alias modDescriptionText: modDescription.text//modDescription的内容
    TextArea{
        id:modDescription
        parent: myPopup.column
        width: parent.width-30
        height: 75
        anchors.horizontalCenter: parent.horizontalCenter
        placeholderText: qsTr("Description")
        //设置超出换行
        wrapMode: Text.Wrap  // 启用自动换行
        background: Rectangle{
            color: "#f5f6f7"
            radius: 7
            width: parent.width
            height: parent.height
            border{
                width: 1
                color:"#dededf"
            }
        }
    }

    Label{
        id:modDescroptionLabel
        parent: myPopup.column
        text: qsTr("Description:")
        height: 10
        font.pixelSize: 16
        anchors.left: parent.left
        anchors.leftMargin: 10
    }

    CustInputIconPath{//选择或输入icon path的框
        id:modIcon
        parent: myPopup.column
        width: parent.width-30
        height: 30
        anchors.horizontalCenter: parent.horizontalCenter
        phText: qsTr("Icon Path")
    }
    Label{
        id:modIconLabel
        parent: myPopup.column
        text: qsTr("Icon Path:")
        height: 10
        font.pixelSize: 16
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    CustInputText{//输入modname框
        id:modName
        parent: myPopup.column
        width: parent.width-30
        height: 30
        anchors.horizontalCenter: parent.horizontalCenter
        placeholderText: qsTr("Mod Name")
    }
    Label{
        id:modNameLabel
        parent: myPopup.column
        text: qsTr("Mod Name:")
        height: 10
        font.pixelSize: 16
        anchors.left: parent.left
        anchors.leftMargin: 10
    }
    onClosed: {
        modIcon.pathStr=""
        modName.text=""
        modDescription.text=""
    }
}
