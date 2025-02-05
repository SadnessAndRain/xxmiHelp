import os
import shutil
from PySide6.QtCore import QAbstractListModel, Qt, QByteArray, Slot
from PySide6.QtQml import QmlElement, QmlSingleton
from model import session,Mod
from functools import wraps
from game import remove_file_prefix
import rarfile

QML_IMPORT_NAME = "ModModel"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
@QmlSingleton
class ModModel(QAbstractListModel):
    Name=Qt.UserRole+7
    Icon=Name+1
    FileName=Icon+1
    Enable=FileName+1
    Description=Enable+1
    Id=Description+1
    def __init__(self, data, parent=None):
        super().__init__(parent)
        self._data = data

    # 从数据库的Mod中获取对应行的数据以列表形式给_data
    def initData(self,game_id, role_id):
        self._data = session.query(Mod).filter(Mod.game_id == game_id, Mod.role_id == role_id).all()

    def roleNames(self):
        mods={
            ModModel.Name: QByteArray(b"name"),
            ModModel.Icon: QByteArray(b"icon"),
            ModModel.FileName: QByteArray(b"fileName"),
            ModModel.Enable: QByteArray(b"enable"),
            ModModel.Description: QByteArray(b"description"),
            ModModel.Id: QByteArray(b"id")
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
        if role == ModModel.Enable:
            return d.enable
        if role == ModModel.Description:
            return d.description
        if role == ModModel.Id:
            return d.id
        return None

    @staticmethod
    def create(engine):  # 该函数会在qml中绑定的视图的对象创建时自动使用
        # data = session.query(Mod).all()
        print("ModModel Data")
        data = []
        return ModModel(data)

    # 修改修饰器,告知要开始重置模型，结束重置模型
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

    #清理_data,gameList切换时使用
    @reload
    @Slot()
    def clearData(self):
        self._data=[]


    # 重新加载
    @reload
    @Slot(int,int)
    def reloadData(self, game_id, role_id):
        self.initData(game_id, role_id)

    #拖动添加mod
    @reload
    @Slot(str,str,str,str,int,int,str, result=bool)#传入参数依次为文件路径，mod名称，mod图标，目标文件夹名(当前所选游戏名)，当前游戏行号，当前角色行号, mod描述
    def addMod(self, file_path, name, icon, target_name, game_id, role_id, description):
        #打印参数
        print("file_path:", file_path , "name:",name, "icon:",icon, "target_name:",target_name, "game_index:",game_id, "role_index:",role_id , "description:",description)
        file_name = os.path.basename(file_path)#mod的文件名带后缀
        #判断文件名是否有表明为压缩包的后缀,有则去掉
        if file_name.endswith(".zip") or file_name.endswith(".rar") or file_name.endswith(".7z"):
            file_name2=os.path.splitext(file_name)[0]
        else:
            file_name2=file_name
        #判断文件名是否已经存在
        if session.query(Mod).filter(Mod.file_name == file_name2, Mod.game_id == game_id).first():
            print("文件名已存在")
            return False
        #处理icon的前缀
        icon=remove_file_prefix(icon)
        #判断icon是否为正常路径,不是则为空字符串
        if not os.path.exists(icon):
            icon=""
        file_path = remove_file_prefix(file_path)#去掉前缀,拿到正常路径
        #将file_path路径的文件移动到Mods目录下名为target_name的文件夹下
        current_path=os.getcwd()#当前路径
        #不启用时存储的完整路径
        target_path=os.path.join(current_path,"Mods",target_name)
        #将file_path路径的文件移动到Mods目录下名为target_name的文件夹下
        if not os.path.exists(target_path):
            print("Mods目录下不存在名为"+target_name+"的文件夹")
            return False
        print(file_path,target_path)
        #移动文件
        shutil.move(file_path,target_path)
        #判断该文件名后缀是否为.zip、.rar、.7z,如果是,则解压到target_path文件夹下
        if file_name.endswith(".zip") or file_name.endswith(".7z"):
            shutil.unpack_archive(os.path.join(target_path,file_name), target_path)
            #删除压缩包
            os.remove(os.path.join(target_path,file_name))
        #如果是.rar文件,则使用rarfile命令解压到target_path文件夹下
        elif file_name.endswith(".rar"):
            with rarfile.RarFile(os.path.join(target_path,file_name)) as rf:
                rf.extractall(path=target_path)
            #删除压缩包
            os.remove(os.path.join(target_path, file_name))
        # #去掉file_name的后缀
        # file_name=os.path.splitext(file_name)[0]
        #将mod信息写入数据库
        mod=Mod(name=name, icon=icon, file_name=file_name2, game_id=game_id, role_id=role_id, description=description)
        session.add(mod)
        session.commit()
        print("addMod", file_name)
        return True

    #删除mod
    @reload
    @Slot(int,str,str)
    def deleteMod(self, index,game_name,target_path):
        #打印参数
        print("deleteMod:", index,"target_path:",target_path)
        mod=self._data[index]
        #根据enable判断该文件目前在哪个个路径下
        if mod.enable:
            file_path=os.path.join(target_path,mod.file_name)
        else:
            file_path=os.path.join(os.getcwd(),"Mods",game_name,mod.file_name)
        #删除文件
        print(file_path)
        # os.remove(file_path)
        shutil.rmtree(file_path)
        #删除数据库中的mod信息
        session.delete(mod)
        session.commit()
        #_data列表中删除该mod
        self._data.remove(mod)
        print("deleteMod:", mod.file_name)

    #修改mod信息
    @reload
    @Slot(int,str,str,str)
    def modifyMod(self, index, name, icon, description):
        #处理下icon的前缀
        icon=remove_file_prefix(icon)
        #判断icon是否为正常路径,不是则为空字符串
        if not os.path.exists(icon):
            icon=""
        id=self._data[index].id
        mod=session.query(Mod).filter(Mod.id == id).first()
        mod.name=name
        mod.icon=icon
        mod.description=description
        session.commit()

    #启用或禁用mod
    # @reload#因为只修改了enable字段,所以重不重新加载都无所谓,加载了会导致动画也要重置,太蠢了
    @Slot(int,str,str)
    def enableMod(self, index, game_name, target_path):
        print("game_name:", game_name, "target_path:", target_path)
        #修改数据库中的enable字段
        id=self._data[index].id
        mod=session.query(Mod).filter(Mod.id == id).first()
        if mod.enable:
            mod.enable=0
            # 修改_data列表中的enable字段
            self._data[index].enable=0
        else:
            mod.enable=1
            # 修改_data列表中的enable字段
            self._data[index].enable=1
        print("enable:", mod.enable)
        session.commit()
        #判断enable的状态,如果是1,将该文件从Mods下的game_name文件夹下移动到target_path文件夹下
        if self._data[index].enable:
            file_path=os.path.join(os.getcwd(), "Mods", game_name, mod.file_name)
            print("from:", file_path, "to:", target_path)
            shutil.move(file_path, target_path)
        #如果是0,将该文件从target_path文件夹下移动到Mods下的game_name文件夹下
        else:
            file_path = os.path.join(target_path, mod.file_name)
            print("from:", file_path, "to:", os.path.join(os.getcwd(), "Mods", game_name))
            shutil.move(file_path, os.path.join(os.getcwd(), "Mods", game_name))

    #在资源管理器中打开mod所在文件夹
    @Slot(str, str, str, int)
    def openModFolder(self, game_name, file_name, target_path, enable):
        #如果是enable==1,则打开target_path目录下的game_name文件夹
        if enable:
            #如果file_name不是文件夹,则打开该文件所在目录
            if not os.path.isdir(os.path.join(target_path, file_name)):
                os.startfile(target_path, file_name)
            else:
                os.startfile(os.path.join(target_path, file_name))
        #如果是enable==0,则打开Mods目录下的game_name目录的file_name文件
        else:
            #如果file_name不是文件夹,则打开该文件所在目录
            if not os.path.isdir(os.path.join(os.getcwd(), "Mods", game_name, file_name)):
                os.startfile(os.path.join(os.getcwd(), "Mods", game_name))
            else:
                os.startfile(os.path.join(os.getcwd(), "Mods", game_name, file_name))

    #添加mod图片
    @reload
    @Slot(str, int, str)
    def addModIcon(self, game_name, id, image_path):
        #前缀处理
        image_path=remove_file_prefix(image_path)
        #目标路径
        target_path=os.path.join(os.getcwd(), "Mods", game_name, "images")
        #判断图片是否已经存在在目标路径下
        if os.path.exists(os.path.join(target_path, os.path.basename(image_path))):
            print("图片已存在")
            dis=os.path.join(target_path, os.path.basename(image_path))
        else:
            dis=shutil.move(image_path, target_path)
        print("addModIcon:", dis)
        mod=session.query(Mod).filter(Mod.id == id).first()
        mod.icon=dis
        session.commit()

