import os
from dataclasses import dataclass
from pathlib import Path
import sys
from PySide6.QtCore import QAbstractListModel, Qt, QUrl, QByteArray, Slot, Signal
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtQml import QmlElement, QmlSingleton
from model import session,Game,Role,Mod
from functools import wraps
from game import remove_file_prefix

QML_IMPORT_NAME = "ModModel"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
@QmlSingleton
class ModModel(QAbstractListModel):
    Name=Qt.UserRole+6
    Icon=Qt.UserRole+7
    FileName=Qt.UserRole+8
    FilePath=Qt.UserRole+9
    def __init__(self, data, parent=None):
        super().__init__(parent)
        self._data = data

    # 从数据库的Mod中获取对应行的数据以列表形式给_data
    def initData(self,game_index, role_index):
        self._data = session.query(Mod).filter(Mod.game_id == game_index, Mod.role_id == role_index).all()

    def roleNames(self):
        mods={
            ModModel.Name: QByteArray(b"name"),
            ModModel.Icon: QByteArray(b"icon"),
            ModModel.FileName: QByteArray(b"fileName"),
            ModModel.FilePath: QByteArray(b"filePath")
        }
        return mods

    def rowCount(self, index):  # 告诉视图模型有多少行(必须实现)
        return len(self._data)

    def data(self, index, role):#返回在索引引用的项目的给定角色下存储的数据。(必须实现)
        d = self._data[index.row()]
        if role == ModModel.Name:
            return d.name
        if role == ModModel.Icon:
            return d.icon
        if role == ModModel.FileName:
            return d.file_name
        if role == ModModel.FilePath:
            return d.file_path
        return None

    @staticmethod
    def create(engine):  # 该函数会在qml中绑定的视图的对象创建时自动使用
        # data = session.query(Mod).all()
        print("ModModel Data")
        data = []
        return ModModel(data)

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

    # 重新加载
    @reload
    @Slot(int,int)
    def reloadData(self, game_index, role_index):
        self.initData(game_index, role_index)