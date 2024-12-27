# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import os
from dataclasses import dataclass
from pathlib import Path
import sys
from PySide6.QtCore import QAbstractListModel, Qt, QUrl, QByteArray, Slot, Signal
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtQml import QmlElement, QmlSingleton
from model import session,Game
from functools import wraps


QML_IMPORT_NAME = "GameModel"
QML_IMPORT_MAJOR_VERSION = 1


@dataclass
class Person:
    name: str
    myrole: str


@QmlElement
@QmlSingleton#将 Python 类注册为 QML 的单例，这意味着 QML 只会创建一个共享的实例，并且所有 QML 组件都可以访问这个全局单例。
class GameModel (QAbstractListModel):
    MyGame = Qt.UserRole + 1
    Path=MyGame+1

    def __init__(self, data, parent=None):
        super().__init__(parent)
        self._data = data#存的列表数据
        # self.initData()


    #从数据库的Game中获取全部数据以列表形式给_data
    def initData(self):
        self._data = session.query(Game).all()


    def roleNames(self):#提供的默认角色以外的角色,在qml使用就必须覆盖.
        games = {
            GameModel.MyGame: QByteArray(b'name'),
            Qt.DisplayRole: QByteArray(b'icon'),
            GameModel.Path: QByteArray(b'path')
        }
        return games

    def rowCount(self, index):#告诉视图模型有多少行(必须实现)
        return len(self._data)

    def data(self, index, role):#返回在索引引用的项目的给定角色下存储的数据。(必须实现)
        d = self._data[index.row()]
        if role == Qt.DisplayRole:
            return d.icon
        if role == Qt.DecorationRole:
            return Qt.black
        if role == GameModel.MyGame:
            return d.name
        if role == GameModel.Path:
            return d.path
        return None

    @staticmethod
    def create(engine):
        # data = [Person('Qt', 'myrole'), Person('PySide', 'role2')]
        data =session.query(Game).all()
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
    @Slot(str,str,str)
    def addGame(self,name,path,icon):
        game = Game(name=name,path=path,icon=icon)
        session.add(game)
        session.commit()
        self.initData()

    #删除game
    @reload
    @Slot(int)
    def deleteGame(self,index):
        id=self._data[index].id
        session.query(Game).filter_by(id=id).delete()
        session.commit()
        self.initData()
        print(index)





if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    view = QQuickView()
    view.setResizeMode(QQuickView.SizeRootObjectToView)

    qml_file = os.fspath(Path(__file__).resolve().parent / 'Game.qml')
    view.setSource(QUrl.fromLocalFile(qml_file))
    if view.status() == QQuickView.Error:
        sys.exit(-1)
    view.show()

    r = app.exec()
    # Deleting the view before it goes out of scope is required to make sure all child QML instances
    # are destroyed in the correct order.
    del view
    sys.exit(r)
