# Copyright (C) 2022 The Qt Company Ltd.
# SPDX-License-Identifier: LicenseRef-Qt-Commercial OR BSD-3-Clause

import os
from dataclasses import dataclass
from pathlib import Path
import sys
from PySide6.QtCore import QAbstractListModel, Qt, QUrl, QByteArray
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtQml import QmlElement, QmlSingleton
from model import session,Game


QML_IMPORT_NAME = "GameModel"
QML_IMPORT_MAJOR_VERSION = 1


@dataclass
class Person:
    name: str
    myrole: str


@QmlElement
@QmlSingleton
class GameModel (QAbstractListModel):
    MyGame = Qt.UserRole + 1

    def __init__(self, data, parent=None):
        super().__init__(parent)
        self._data = data
        # self.initData()


    #从数据库的Game中获取全部数据以列表形式给_data
    def initData(self):
        self._data = session.query(Game).all()


    def roleNames(self):#提供的默认角色以外的角色,在qml使用就必须覆盖.
        games = {
            GameModel.MyGame: QByteArray(b'name'),
            Qt.DisplayRole: QByteArray(b'icon')
        }
        return games

    def rowCount(self, index):#告诉视图模型有多少行
        return len(self._data)

    def data(self, index, role):#返回在索引引用的项目的给定角色下存储的数据。
        d = self._data[index.row()]
        if role == Qt.DisplayRole:
            return d.icon
        if role == Qt.DecorationRole:
            return Qt.black
        if role == GameModel.MyGame:
            return d.name
        return None

    @staticmethod
    def create(engine):
        # data = [Person('Qt', 'myrole'), Person('PySide', 'role2')]
        data =session.query(Game).all()
        print(data)
        return GameModel(data)


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
