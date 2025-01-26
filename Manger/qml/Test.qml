import QtQuick
import QtQuick.Controls
import QtQuick.Window
import Qt5Compat.GraphicalEffects

import QtQuick.Controls.Basic


Rectangle {
    width: 200
    height: 200

    RoundButton {
        id: roundBtn
        width: 100
        height: 50
        text: "Click me"

        // background 属性定义
        background: Rectangle {
            id: btnBackground
            color: "lightblue"
            border.color: "blue"
            radius: 10
        }

        // 在按钮点击时访问和修改背景属性
        MouseArea {
            anchors.fill: parent
            onClicked: {
                console.log(btnBackground.color); // 输出背景的 color 属性
                btnBackground.color = "green"; // 修改背景的 color 属性
            }
        }
    }
}



