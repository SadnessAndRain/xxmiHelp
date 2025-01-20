import QtQuick
import QtQuick.Controls
MouseArea{
    property alias delelt: deleteItenm
    property alias modify: modifyItem
    Menu{
        id:myMenu
        //打开和关闭的动画
        enter: Transition {
            NumberAnimation { property: "scale"; from: 0.5; to: 1.0; duration: 70 }
            NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration:70 }
        }

        exit: Transition {
            NumberAnimation { property: "scale"; from: 1.0; to: 0.5; duration: 70 }
            NumberAnimation { property: "opacity"; from: 1.0; to: 0.0; duration: 70 }
        }
        MenuItem{
            id:deleteItenm
            text: qsTr("Delete")
        }
        MenuItem{
            id:modifyItem
            text: qsTr("Modify")
        }
    }
    anchors.fill: parent
    acceptedButtons: Qt.RightButton
    onClicked: {
        myMenu.popup()
    }
}

