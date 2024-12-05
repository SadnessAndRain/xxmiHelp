import re#正则匹配
import keyboard#键盘输入
import pyautogui#鼠标操作

# 定义函数实现读取行号
def find_lines(file_path, param):
    param_lines = []  # 用于存储包含 "draw" 的行号
    pattern=r'\b{}\b'.format(param)  # 正则表达式匹配参数
    try:
        with open(file_path, 'r', encoding='utf-8') as file:  # 打开文件
            for line_number, line in enumerate(file, start=1):  # 逐行读取文件并记录行号
                if re.search(pattern, line):  # 如果匹配参数
                    param_lines.append(line_number)  # 如果匹配，添加行号到数组
    except FileNotFoundError:
        print(f"文件未找到: {file_path}")
    except Exception as e:
        print(f"发生错误: {e}")
    return param_lines

#在指定的行号前插入文本，如果已经存在则不重复添加
def add_text_before_line(file_path, target_line, text_to_add):
    try:
        # 读取文件内容
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()

        # 确保目标行存在
        if target_line < 1 or target_line > len(lines):
            print(f"错误：指定的行号 {target_line} 不在文件范围内（1-{len(lines)}）。")
            return

        #备份下行原内容
        backup_line = lines[target_line - 1]
        #判断该符号是否已经存在在目标行中，在则直接返回
        if text_to_add in lines[target_line - 1]:
            return
        # 在目标行的行头添加文本
        lines[target_line - 1] = text_to_add + lines[target_line - 1]

        # 写回文件
        with open(file_path, 'w', encoding='utf-8') as file:
            file.writelines(lines)

        print(f"已成功在第 {target_line} 行前添加文本：{text_to_add}")
    except FileNotFoundError:
        print(f"错误：文件 '{file_path}' 未找到！")
    except PermissionError:
        print(f"错误：没有权限访问文件 '{file_path}'！")
    except Exception as e:
        print(f"发生未知错误：{e}")

##在指定的行号中去掉某个字符
def remove_text_in_line(file_path, target_line, char_to_remove):
    try:
        # 读取文件内容
        with open(file_path, 'r', encoding='utf-8') as file:
            lines = file.readlines()

        # 确保目标行存在
        if target_line < 1 or target_line > len(lines):
            print(f"错误：指定的行号 {target_line} 不在文件范围内（1-{len(lines)}）。")
            return

        # 备份下行原内容
        backup_line = lines[target_line - 1]

        # 在目标行中去掉指定字符
        lines[target_line - 1] = lines[target_line - 1].replace(char_to_remove, '')

        # 写回文件
        with open(file_path, 'w', encoding='utf-8') as file:
            file.writelines(lines)

        print(f"已成功在第 {target_line} 行中去掉字符 '{char_to_remove}'")
    except FileNotFoundError:
        print(f"错误：文件 '{file_path}' 未找到！")
    except PermissionError:
        print(f"错误：没有权限访问文件 '{file_path}'！")
    except Exception as e:
        print(f"发生未知错误：{e}")


if __name__ == '__main__':
    #预设
    ini_file = 'C:/wbr/test/xxmiHelp/mod.ini'  # ini 文件路径
    param='draw'#要找的字符串
    text_to_add = ";"  # 要添加的字符

    # 获取行数列表
    line_positions = find_lines(ini_file,param)
    print(f"包含 '{param}' 的行号: {line_positions}")
    # 列表的当前位置
    current_line = 0
    bl=False
    #打印下当前行号
    print(f"当前行号: {line_positions[current_line]}")

    while True:
        # 等待键盘输入
        key = keyboard.read_event(suppress=False)  # 等待键盘事件
        if key.event_type=='down' and key.name == "s":
            bl=not bl
            if bl:
                # 添加符号
                add_text_before_line(ini_file, line_positions[current_line], text_to_add)
            else:
                # 去掉符号
                remove_text_in_line(ini_file,line_positions[current_line],text_to_add)
            #按下f10
            keyboard.press_and_release('F10')#更底层的键盘操作
            #pyautogui.press("f11")

        elif key.event_type=='down' and key.name == "n":
            current_line = (current_line +1)%len(line_positions)
        elif key.event_type=='down' and key.name == "q":
            # 退出程序
            break
        # 只有按下事件才会触发打印当前行号
        if key.event_type=='down':
            print(f"当前行号: {line_positions[current_line]}")



