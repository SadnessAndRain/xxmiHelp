import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt5Compat.GraphicalEffects


Rectangle{
    property alias rect2: rect2
    width: 400
    height: 400
    color:"green"
    Rectangle{
        id:rect2
        anchors.centerIn: parent
        color: "blue"
        width: 300
        height: 300
    }
    Rectangle{
        id:rect

        color: "red"
        width: 200
        height: 200
        parent: rect2
    }

}
