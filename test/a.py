#!/usr/bin/env python
# qml-test2.py
'''
（2）QML显式的调用Python函数，并有返回

这个例子跟上一个相类似，只是这次调用Python的函数具有返回值功能。

运行程序后，点击鼠标，左上角会显示数字30。
'''

from PyQt5 import QtGui, QtWidgets, QtCore
from PyQt5.QtCore import *
from PyQt5.QtGui import *
from PyQt5.QtWidgets import *
from PyQt5.QtQuick import *
from PyQt5.QtQml import *
import random
import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl, QObject, Signal, Slot


class MyClass(QObject):
    @pyqtSlot(int, result=str)
    def returnValue(self, value):
        return str(value + 10)

    @pyqtSlot(int, result=list)
    def returnList(self, value):
        return [1, 2, 3]

    # @pyqtSlot(int,result=QVariant)
    # def returnDict(self, value):
    #     return QJsonDocument.fromJson(b'{"test": null}')

    @pyqtSlot(result=QVariant)
    def returnDict(self, ):
        return {"a": 1, "b": 2} # 键必须是字符串

    # @pyqtSlot(int,result=QVariant)
    # def returnDict(self, value):
    #     return QJsonDocument.fromJson(b'{"test": null}')
    #     # return QVariant()
    #     # return QJsonValue()


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    engine = QQmlApplicationEngine()

    path = 'main.qml'  # 加载的QML文件
    con = MyClass()

    # view = QQuickView()
    # view.engine().quit.connect(app.quit)
    # view.setSource(QUrl(path))

    engine.rootContext().setContextProperty('con', con)
    engine.load(QUrl("main.qml"))
    # context = view.rootContext()
    # context.setContextProperty("con", con)
    if not engine.rootObjects():
        sys.exit(-1)
    exit_code = app.exec()
    del engine
    sys.exit(exit_code)
    # view.show()
    # app.exec_()

