
from PySide6.QtCore import QAbstractListModel, Qt, QByteArray, Slot
from PySide6.QtQml import QmlElement, QmlSingleton
from model import session,Game,Role,Mod
from functools import wraps
from game import remove_file_prefix
import shutil
import os

QML_IMPORT_NAME = "RoleModel"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
@QmlSingleton
class RoleModel (QAbstractListModel):
    Name=Qt.UserRole+5
    Icon=Name+1
    Id=Icon+1

    def __init__(self, data, parent=None):
        super().__init__(parent)
        self._data = data#存的列表数据
        # self.create()

    # 从数据库的Role中获取对应id的数据以列表形式给_data
    def initData(self,id):
        self._data = session.query(Role).filter(Role.game_id==id).all()

    def roleNames(self):#提供的默认角色以外的角色,在qml使用就必须覆盖.回一个 Python 字典，其中自定义角色和角色名称作为键值对
        roles = {
            RoleModel.Name: QByteArray(b'name'),
            RoleModel.Icon: QByteArray(b'icon'),
            RoleModel.Id: QByteArray(b'id')
        }
        return roles

    def rowCount(self, index):#告诉视图模型有多少行(必须实现)
        return len(self._data)

    def data(self, index, role):#返回在索引引用的项目的给定角色下存储的数据。(必须实现)
        d = self._data[index.row()]
        if role == RoleModel.Name:
            return d.name
        if role == RoleModel.Icon:
            return d.icon
        if role == RoleModel.Id:
            return d.id
        return None

    @staticmethod
    def create(engine):#该函数会在qml中绑定的视图的对象创建时自动使用
        # data = session.query(Role).all()
        print("RoleModel Data")
        data=[]
        return RoleModel(data)

    # 重新加载
    @staticmethod  # 作为静态方法，可以直接调用，不需要实例化对象
    def reload(fn):
        @wraps(fn)
        def wrapper(self, *args, **kwargs):
            self.beginResetModel()
            try:
                return fn(self, *args, **kwargs)
            finally:
                self.endResetModel()
        return wrapper

    #重新加载
    @reload
    @Slot(int)
    def reloadData(self,id):
        self.initData(id)

    #添加角色
    @reload
    @Slot(str,str,int)
    def addRole(self,name,icon,game_id):
        icon = remove_file_prefix(icon)
        role = Role(name=name,icon=icon,game_id=game_id)
        session.add(role)
        session.commit()
        self._data.append(role)

    #删除角色
    @reload
    @Slot(int, int, str, str)
    def deleteRole(self,role_id, game_id, game_name, target_path):
        #从Mod数据库中检索出所有role_id和game_id且enable=0相关的mod
        mods = session.query(Mod).filter(Mod.game_id==game_id, Mod.role_id==role_id, Mod.enable==0).all()
        #删除未启用的mod文件
        for mod in mods:
            shutil.rmtree(os.path.join(os.getcwd(), "Mods", game_name, mod.name))
            #数据库同步删除
            session.delete(mod)
        #从Mod数据库中检索出所有role_id和game_id且enable=1相关的mod
        mods = session.query(Mod).filter(Mod.game_id==game_id, Mod.role_id==role_id, Mod.enable==1).all()
        #删除启用的mod文件
        for mod in mods:
            shutil.rmtree(os.path.join(target_path, mod.name))
            #数据库同步删除
            session.delete(mod)
        #数据库删除角色
        role = session.query(Role).filter(Role.id==role_id).first()
        session.delete(role)
        session.commit()
        self._data.remove(role)

    #修改角色
    @reload
    @Slot(int,str,str)
    def modifyRole(self,id,name,icon):
        role = session.query(Role).filter(Role.id==id).first()
        role.name = name
        role.icon = remove_file_prefix(icon)
        session.commit()
        self.initData(id)

    #清理data
    @reload
    @Slot()
    def clearData(self):
        self._data = []