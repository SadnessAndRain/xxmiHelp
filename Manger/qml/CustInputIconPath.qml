import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
Row{
    //对外暴露的属性
    property alias pathStr: inputPathText.text//文本
    property alias phText: inputPathText.placeholderText//占位文本
    // spacing: 20
    TextField{
        id:inputPathText
        height: parent.height
        anchors.left: parent.left
        anchors.right: openFolderBtn.left
        anchors.rightMargin: 20
        font.pixelSize: 16
        text:fileDialog.selectedFolder===undefined ? "":fileDialog.selectedFolder
        placeholderText: "Path"
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
    MyButton{
        id:openFolderBtn
        width: 100
        anchors.right: parent.right
        height: parent.height
        text: qsTr("Open Folder")
        onClicked: {
            fileDialog.open()
        }
    }
    FileDialog {
        id: fileDialog
        //设置对话框打开时的默认文件夹路径,会报StandardPaths的ReferenceError错
        // currentFolder: StandardPaths.standardLocations(StandardPaths.DocumentsLocation)[0]//standardLocations() 返回一个路径列表，表示操作系统上的标准位置。参数是一个枚举值，表示需要查询的目录类型,这里是文档目录.[0]返回路径列表,因为某些系统上可能有多个路径
        onAccepted: inputPathText.text=fileDialog.selectedFile
    }
}
