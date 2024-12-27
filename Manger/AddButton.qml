import QtQuick
import QtQuick.Controls


RoundButton{
    id:addButton
    width: 170
    height: 50
    radius: 7
    background: Rectangle{
        id:buttonBG
        width: parent.width-10
        height: parent.height-10
        anchors.centerIn: parent
        radius: parent.radius
        color: "#F5F8FD"
        //设置边框
        border{
            color: "#bed2fe"
            width: 2
        }
    }
    icon.source: "./image/add.png"
    icon.width: 20
    icon.height: 20
}
