import QtQuick
import QtQuick.Controls

RoundButton{
    // property alias imageSource: image.source//暴露图片的source属性
    id:modBtn
    background: Rectangle{
        clip: true
        anchors.fill: parent
        anchors.margins: 10
        color: modBtn.hovered ? "#e4e6e7" : "#f5f6f7"
        radius: 9
        //颜色过渡
        Behavior on color { // 添加颜色过渡动画
            ColorAnimation {
                duration: 150 // 动画持续时间（毫秒）
                easing.type: Easing.InOutQuad // 动画缓动类型
            }
        }
    }
}


