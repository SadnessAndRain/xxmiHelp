import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
MyPopup{
    id:myPopup
    property alias modNameText: modName.text//name文本框内容
    property alias modIconText: modIcon.pathStr//icon文本框内容
    property alias modDescriptionText: modDescription.text//modDescription的内容
    Column{
        parent: myPopup.column
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
        spacing: 2
        Label{
            id:modNameLabel
            text: qsTr("Mod Name:")
            height: 25
            font.pixelSize: 16
        }
        CustInputText{//输入modname框
            id:modName
            width: myPopup.column.width-20
            height: 30
            placeholderText: qsTr("Mod Name")
        }
        Label{
            id:modIconLabel
            text: qsTr("Icon Path:")
            height: 25
            font.pixelSize: 16
        }
        CustInputIconPath{//选择或输入icon path的框
            id:modIcon
            width: myPopup.column.width-20
            height: 30
            phText: qsTr("Icon Path")
        }
        Label{
            id:modDescroptionLabel
            text: qsTr("Description:")
            height: 25
            font.pixelSize: 16
        }
        TextArea{
            id:modDescription
            width: myPopup.column.width-20
            height: 75
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
    }
    onClosed: {
        modIcon.pathStr=""
        modName.text=""
        modDescription.text=""
    }
}
