import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic//用来设置主题,方便控件自定义,不然会报错

TextField{
    id:inputText
    font.pixelSize: 16
    background: Rectangle{
        color: "#f5f6f7"
        radius: 7
        width: parent.width
        height: parent.height
        border{
            width: 1
            color:"#dededf"
        }
    }
}





