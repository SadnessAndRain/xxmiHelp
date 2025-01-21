import QtQuick
import QtQuick.Controls
import RoleModel
import ModModel


ListView{
    //当前所选role行的id
    property int currentRoleIndex :-1
    //当前所选game行索引
    property int currentGameIndex :-1
    //将buttonGroup暴露出来
    property alias roleButtonGroup:roleButtonGroup
    property string currentTargetPath//当前game的path
    property string currentGameName//当前game的name
    id:roleListView
    anchors.fill: parent
    model: RoleModel
    ButtonGroup { id: roleButtonGroup }
    //修改窗口
    RoleDialog{
        id:roleModifyDialog
        Connections{
            target: roleModifyDialog.confirmation
            function onClicked(){
                RoleModel.modifyRole(roleListView.currentIndex,roleModifyDialog.roleNameText, roleModifyDialog.roleIconText)
                roleModifyDialog.close()
            }
        }
    }
    //委托部分
    delegate: Component{
        RoleListBtn{
            id:roleBtn
            text: model.name
            ButtonGroup.group: roleButtonGroup
            //弹出的菜单栏
            MyMenu{
                id:roleMenu
                onClicked: {//设置当前索引
                    roleListView.currentIndex=id
                }
            }
            //menu的delete逻辑部分
            Connections{
                target: roleMenu.delelt
                function onTriggered() {
                    RoleModel.deleteRole(id, roleListView.currentGameIndex, roleListView.currentGameName, roleListView.currentTargetPath)
                }
            }
            //menu的modify逻辑部分
            Connections{
                target: roleMenu.modify
                function onTriggered(){
                    roleModifyDialog.open()
                    roleModifyDialog.roleNameText=model.name
                    roleModifyDialog.roleIconText=model.icon
                }
            }
            //当点击role列表的按钮加载modList
            onClicked: {
                currentRoleIndex=id
                ModModel.reloadData(roleListView.currentGameIndex,id)
            }
        }
    }
}




