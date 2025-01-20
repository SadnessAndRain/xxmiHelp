import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt5Compat.GraphicalEffects

import QtQuick.Controls.Basic

Switch {
    id: control
    text: qsTr("Switch")

    indicator: Rectangle {
        implicitWidth: 48
        implicitHeight: 26
        x: control.leftPadding
        y: parent.height / 2 - height / 2
        radius: 13
        color: control.checked ? "#17a81a" : "#ffffff"
        border.color: control.checked ? "#17a81a" : "#cccccc"

        Rectangle {
            x: control.checked ? parent.width - width : 0
            width: 26
            height: 26
            radius: 13
            color: control.down ? "#cccccc" : "#ffffff"
            border.color: control.checked ? (control.down ? "#17a81a" : "#21be2b") : "#999999"
            //添加移动动画
            Behavior on x{
                NumberAnimation {
                    duration: 150 // 动画时长 (毫秒)
                    easing.type: Easing.InOutQuad // 缓动类型
                }
            }
        }
        //添加颜色过渡动画
        Behavior on color {
            ColorAnimation {
                duration: 200 // 动画持续时间（毫秒）
                easing.type: Easing.InOutQuad // 动画缓动类型
            }
        }

    }

    contentItem: Text {
        text: control.text
        font: control.font
        opacity: enabled ? 1.0 : 0.3
        color: control.down ? "#17a81a" : "#21be2b"
        verticalAlignment: Text.AlignVCenter
        leftPadding: control.indicator.width + control.spacing
    }
}
