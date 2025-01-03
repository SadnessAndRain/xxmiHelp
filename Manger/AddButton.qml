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
        color: addButton.hovered? "#e4e6e7":"#F5F8FD"
        //设置边框
        border{
            color: "#bed2fe"
            width: 2
        }
        Behavior on color { // 添加颜色过渡动画
            ColorAnimation {
                duration: 150 // 动画持续时间（毫秒）
                easing.type: Easing.InOutQuad // 动画缓动类型
            }
        }
    }
    icon.source: "./image/add.png"
    icon.width: 20
    icon.height: 20
}
