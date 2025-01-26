import QtQuick
import QtQuick.Controls

RoundButton{
    id:roleRoundBtn
    width: 250
    height: 38
    radius: 9

    autoExclusive: true//启用排他
    checkable: true//可选中
    background: Rectangle {
        id:bg
        // anchors.top: parent.top
        // anchors.topMargin: 1
        // anchors.bottom: parent.bottom
        // anchors.bottomMargin: 1
        anchors.centerIn: parent
        height: 30
        width: 230
        anchors.horizontalCenter: parent.horizontalCenter
        color: roleRoundBtn.hovered ? "#d3def6" : "transparent"// 选中时变成绿色，未选中时变成灰色
        radius: parent.radius
        border.color: "transparent" // 去掉边框
        //颜色过渡
        // Behavior on color { // 添加颜色过渡动画
        //     ColorAnimation {
        //         duration: 150 // 动画持续时间（毫秒）
        //         easing.type: Easing.InOutQuad // 动画缓动类型
        //     }
        // }
    }
}
