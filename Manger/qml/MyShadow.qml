import QtQuick
import Qt5Compat.GraphicalEffects

Rectangle {
    id:mainRec
    width: parent.width-20
    height: parent.height-20
    anchors.centerIn: parent
    color:"transparent"
    //边缘阴影
    DropShadow{
        anchors.fill: parent
        horizontalOffset: 0
        verticalOffset: 0
        radius: 12.0
        samples: 25
        color: "#80000000"
        spread: 0.0
        source: parent
    }
}
