# coding:utf8
__author__ = 'yh'

import os
import pandas as pd

basedir = 'H:\Pycharm\sql_shibie\data'
filelist = os.listdir(basedir)
df_list = []

# 循环读取 basedir下面的内容，文件名为 'legit'的是合法内容，malicious的是 恶意sql语句
for file in filelist:
    df = pd.read_csv(os.path.join(basedir, file), sep='|||', names=['raw_sql'], header=None)
    df['type'] = 'legit' if file.split('.')[0] == 'legit' else 'malicious'
    df_list.append(df)

# 将内容放入 dataframe对象
dataframe = pd.concat(df_list, ignore_index=True)

dataframe.dropna(inplace=True)

# 统计内容
print dataframe['type'].value_counts()

# 查看前五个
dataframe.head()