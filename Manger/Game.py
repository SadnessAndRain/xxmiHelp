# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import os
from dataclasses import dataclass

from PySide6.QtCore import QAbstractListModel, Qt, QByteArray, Slot
from PySide6.QtQml import QmlElement, QmlSingleton
from model import session,Game,Role,Mod
from functools import wraps
import shutil


QML_IMPORT_NAME = "GameModel"
QML_IMPORT_MAJOR_VERSION = 1


@dataclass
class Person:
    name: str
    myrole: str


@QmlElement#将一个 Python 类注册为 QML 类型
@QmlSingleton#将 Python 类注册为 QML 的单例，这意味着 QML 只会创建一个共享的实例，并且所有 QML 组件都可以访问这个全局单例。
class GameModel (QAbstractListModel):
    MyGame = Qt.UserRole + 1
    Path=Qt.UserRole + 2
    Icon=Qt.UserRole + 3
    Id=Qt.UserRole + 4

    def __init__(self, data, parent=None):
        super().__init__(parent)
        self._data = data#存的列表数据
        # self.initData()


    #从数据库的Game中获取全部数据以列表形式给_data
    def initData(self):
        self._data = session.query(Game).all()


    def roleNames(self):#提供的默认角色以外的角色,在qml使用就必须覆盖.回一个 Python 字典，其中自定义角色和角色名称作为键值对
        games = {
            GameModel.MyGame: QByteArray(b'name'),
            # Qt.DisplayRole: QByteArray(b'x'),
            GameModel.Path: QByteArray(b'path'),
            GameModel.Icon: QByteArray(b'icon'),
            GameModel.Id: QByteArray(b'id')
        }
        return games

    def rowCount(self, index):#告诉视图模型有多少行(必须实现)
        return len(self._data)

    def data(self, index, role):#返回在索引引用的项目的给定角色下存储的数据。(必须实现)
        d = self._data[index.row()]
        if role == Qt.DisplayRole:
            return d.x
        if role == Qt.DecorationRole:
            return Qt.black
        if role == GameModel.MyGame:
            return d.name
        if role == GameModel.Path:
            return d.path
        if role == GameModel.Icon:
            return d.icon
        if role == GameModel.Id:
            return d.id
        return None

    @staticmethod
    def create(engine):#自动调用，创建单例对象，返回给qml
        # data = [Person('Qt', 'myrole'), Person('PySide', 'role2')]
        data =session.query(Game).all()
        print("GameModel data")
        print(data)
        return GameModel(data)

    # 重新加载
    @staticmethod#作为静态方法，可以直接调用，不需要实例化对象
    def reload(fn):
        @wraps(fn)
        def wrapper(self,*args, **kwargs):
            self.beginResetModel()
            try:
                return fn(self, *args, **kwargs)
            finally:
                self.endResetModel()
        return wrapper

    #添加game
    @reload
    @Slot(str,str,str, result=bool)
    def addGame(self,name,path,icon):
        #数据库中查找是否有相同的name
        if session.query(Game).filter_by(name=name).first() is not None:
            return False
        path=remove_file_prefix(path)#前缀处理
        icon=remove_file_prefix(icon)#前缀处理
        # 在当前目录下的Mods文件夹中创建名为name的文件夹
        os.makedirs(os.path.join(os.getcwd(), "Mods", name), exist_ok=True)
        # 在当前name文件夹下创建images文件夹
        os.makedirs(os.path.join(os.getcwd(), "Mods", name, "images"), exist_ok=True)
        # 在当前name文件夹下创建sounds文件夹
        game = Game(name=name,path=path,icon=icon)
        session.add(game)
        session.commit()
        self.initData()
        return True


    #删除game
    @reload
    @Slot(int)
    def deleteGame(self,id):
        #同时删除Role表中该game的关联数据
        session.query(Role).filter_by(game_id=id).delete()
        #获取该game的path
        path=session.query(Game).filter_by(id=id).first().path
        #获取mod表中enabled=1且game_id=id的所有数据
        mods=session.query(Mod).filter_by(enable=1,game_id=id).all()
        #遍历mods,将path下名为file_name的文件夹都删除
        for mod in mods:
            mod_path=os.path.join(path,mod.file_name)
            if os.path.exists(mod_path):
                shutil.rmtree(mod_path)
        #同时删除Mod表中该game的关联数据
        session.query(Mod).filter_by(game_id=id).delete()
        #同时删除Mods文件夹中该name的文件夹
        name=session.query(Game).filter_by(id=id).first().name
        shutil.rmtree(os.path.join(os.getcwd(),"Mods",name))
        session.commit()
        #删除数据库中的game数据
        session.query(Game).filter_by(id=id).delete()
        session.commit()
        self.initData()
        print(id)


    # 修改game
    @reload
    @Slot(int,str,str,str)
    def modifyGame(self,id,name,path,icon):
        path=remove_file_prefix(path)#前缀处理
        icon=remove_file_prefix(icon)#前缀处理
        game = session.query(Game).filter_by(id=id).first()
        #使用shutil修改Mods下的文件夹名称
        os.rename(os.path.join(os.getcwd(),"Mods",game.name),os.path.join(os.getcwd(),"Mods",name))
        game.name=name
        game.path=path
        game.icon=icon
        session.commit()
        self.initData()

#去掉file:///前缀
def remove_file_prefix(path):
    prefix = "file:///"
    if path.startswith(prefix):
        return path[len(prefix):]
    return path


# if __name__ == '__main__':
#     app = QGuiApplication(sys.argv)
#     view = QQuickView()
#     view.setResizeMode(QQuickView.SizeRootObjectToView)
#
#     qml_file = os.fspath(Path(__file__).resolve().parent / 'Game.qml')
#     view.setSource(QUrl.fromLocalFile(qml_file))
#     if view.status() == QQuickView.Error:
#         sys.exit(-1)
#     view.show()
#
#     r = app.exec()
#     # Deleting the view before it goes out of scope is required to make sure all child QML instances
#     # are destroyed in the correct order.
#     del view
#     sys.exit(r)
