import QtQuick
import QtQuick.Controls
RoundButton{
    id:myBtn
    radius: 7
    height: 30
    width: 100
    text:qsTr("otto")
    font.pixelSize: 13
    palette.text: "#1456f0"

    background: Rectangle{
        radius: parent.radius
        anchors.fill: parent
        color:myBtn.hovered? "#e0e9ff":"white"
        border{
            color: "#1456f0"
            width: 1
        }
        //颜色过渡
        Behavior on color { // 添加颜色过渡动画
            ColorAnimation {
                duration: 200 // 动画持续时间（毫秒）
                easing.type: Easing.InOutQuad // 动画缓动类型
            }
        }
    }
}
