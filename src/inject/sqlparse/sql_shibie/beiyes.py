# coding:utf-8
import json
import os
from time import time
import sqlparse
# import string



def parse_sql(raw_sql):
    parsed_sql = []
    sql = sqlparse.parse(unicode(raw_sql, 'utf-8'))
    for parse in sql:
        for token in parse.tokens:
            if token._get_repr_name() != 'Whitespace':
                parsed_sql.append(token._get_repr_name())
    return parsed_sql


def read_and_parse(basedir):
    start = time()
    df_list = []
    filelist = os.listdir(basedir)
    # 循环读取 basedir下面的内容，文件名为 'legit'的是合法内容，malicious的是 恶意sql语句
    for file in filelist:
        i = 0
        input = open(basedir + '/' + file)
        for line in input.readlines():
            pf = {}
            line = line.replace("\n", "")
            pf['text'] = line
            pf['sql'] = parse_sql(line)
            df_list.append(pf)

    stop = time()
    print '读文件解析用了：', (stop - start), '秒'

    return df_list


def count_sql(allMap, df_list):
    start = time()
    maps = []
    for li in df_list:
        map = {}

        for word in li['sql']:
            if word is not 'Identifier':
                if word in map:
                    map[word] += 1
                else:
                    map[word] = 1
                if word not in allMap:
                    allMap[word] = len(allMap) + 1

        map['len'] = len(li['sql'])
        maps.append(map)
    stop = time()

    print '统计sql用了：', (stop - start), '秒'
    return maps


def creat_matrix(allMap, maps):
    if 'len' not in allMap:
        allMap['len'] = len(allMap) + 1

    start = time()
    matrix = []
    lenth = len(allMap)
    for map in maps:
        list = [0] * lenth
        for key, value in map.iteritems():
            list[allMap[key] - 1] = value

        matrix.append(list)
    stop = time()
    print '生成矩阵用了：', (stop - start), '秒'

    return matrix


basedir_good = 'good'
basedir_bad = 'data'

df_list_bad = read_and_parse(basedir_bad)
df_list_good = read_and_parse(basedir_good)

allMap = {}
maps_bad = count_sql(allMap, df_list_bad)
maps_good = count_sql(allMap, df_list_good)

matrix_bad = creat_matrix(allMap, maps_bad)
matrix_good = creat_matrix(allMap, maps_good)

start = time()

out_put = open('out_bad.js', 'w')
out_list = []
i = 0
print 'bad row:', len(matrix_bad)
for row in matrix_bad:
    i += 1
    j = 0
    for value in row:
        j += 1
        out_list.append([j, i, value])

out_put.write("var bad=" + json.dumps(out_list))
out_put.close()

out_put = open('out_good.js', 'w')
out_list = []
i = 0
print 'good row:', len(matrix_good)
for row in matrix_good:
    i += 1
    j = 0
    for value in row:
        j += 1
        out_list.append([j, i, value])

out_put.write("var good=" + json.dumps(out_list))
out_put.close()

stop = time()
print '输出文件用了：', (stop - start), '秒'
print allMap



########################################

out_put = open('matrix_bad.js', 'w')
out_put.write(json.dumps(matrix_bad))
out_put.close()

out_put = open('matrix_good.js', 'w')
out_put.write(json.dumps(matrix_good))
out_put.close()

out_put = open('allMap.js', 'w')
out_put.write(json.dumps(allMap))
out_put.close()