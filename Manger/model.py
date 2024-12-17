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


# 定义Student类
class Game(Base):
    __tablename__ = 'game'

    id = Column(Integer, autoincrement=True, primary_key=True)
    name = Column(String(50), nullable=False)
    icon = Column(String(50), nullable=True)

    def __repr__(self):
        return f"Game(id='{self.id}', name='{self.name}', icon='{self.icon}')"