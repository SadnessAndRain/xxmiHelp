from sqlalchemy import Column, Integer, String, create_engine, Sequence
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker

# 创建一个基类，用于声明类定义
Base = declarative_base()

# 连接到 SQLite 数据库
engine = create_engine('sqlite:///mod.db')

# 创建一个用于数据库交互的Session类
Session = sessionmaker(bind=engine)
# 实例化会话
session = Session()


# 定义game类
class Game(Base):
    __tablename__ = 'game'

    id = Column(Integer, autoincrement=True, primary_key=True)
    name = Column(String(255), nullable=False)
    icon = Column(String(255), nullable=True)
    path = Column(String(255), nullable=True)

    def __repr__(self):
        return f"Game(id='{self.id}', name='{self.name}', icon='{self.icon}', path='{self.path}')"

#定义role类
class Role(Base):
    __tablename__ = 'role'
    id = Column(Integer, autoincrement=True, primary_key=True)
    name = Column(String(255), nullable=False)#角色名称
    icon = Column(String(255), nullable=True)#图标
    game_row = Column(Integer, nullable=True)#游戏索引

    def __repr__(self):
        return f"Role(id='{self.id}', name='{self.name}', icon='{self.icon}')"

#定义mod类
class Mod(Base):
    __tablename__ ='mod'
    id = Column(Integer, autoincrement=True, primary_key=True)
    name = Column(String(255), nullable=True)#mod名称
    icon = Column(String(255), nullable=True)#图标
    game_id = Column(Integer, nullable=False)#游戏所处的行索引
    role_id = Column(Integer, nullable=False)#角色所处的行索引
    file_name = Column(String(255), nullable=False)#mod文件名称
    # file_path = Column(String(50), nullable=False)#mod不启用时存放的文件路径
    #启用,0为未启用，1为启用
    enable = Column(Integer, nullable=False, default=0)
    #mod的描述
    description = Column(String(255), nullable=True)
    def __repr__(self):
        return f"Mod(id='{self.id}', name='{self.name}', icon='{self.icon}', game_id='{self.game_id}', role_id='{self.role_id}', file_name='{self.file_name}', enable='{self.enable}' , description='{self.description}')"

