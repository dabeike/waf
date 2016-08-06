# coding:utf8
import json
import os
from time import time
import sqlparse

__author__ = 'yh'
# Example of Naive Bayes implemented from Scratch in Python
import csv
import random
import math


def loadCsv(filename):
    lines = csv.reader(open(filename, "rb"))
    dataset = list(lines)
    for i in range(len(dataset)):
        dataset[i] = [float(x) for x in dataset[i]]
    return dataset


def splitDataset(dataset, splitRatio):
    print len(dataset)
    trainSize = int(len(dataset) * splitRatio)
    trainSet = []
    copy = list(dataset)
    while len(trainSet) < trainSize:
        index = random.randrange(len(copy))
        trainSet.append(copy.pop(index))
    return [trainSet, copy]


def separateByClass(dataset):
    separated = {}
    for i in range(len(dataset)):
        vector = dataset[i]
        if (vector[-1] not in separated):
            separated[vector[-1]] = []
        separated[vector[-1]].append(vector)
    return separated


def mean(numbers):
    return sum(numbers) / float(len(numbers))


def stdev(numbers):
    avg = mean(numbers)
    variance = sum([pow(x - avg, 2) for x in numbers]) / float(len(numbers) - 1)
    return math.sqrt(variance)


def summarize(dataset):
    summaries = [(mean(attribute), stdev(attribute)) for attribute in zip(*dataset)]
    # del summaries[-1]
    return summaries


def summarizeByClass(dataset):
    separated = separateByClass(dataset)
    summaries = {}
    for classValue, instances in separated.iteritems():
        summaries[classValue] = summarize(instances)
    return summaries


def calculateProbability(x, mean, stdev):
    chu = (2 * math.pow(stdev, 2))
    if chu == 0.0:
        chu = 0.00000000000000000001
    exponent = math.exp(-(math.pow(x - mean, 2) / chu))
    re_chu = (math.sqrt(2 * math.pi) * stdev)
    if re_chu == 0.0:
        re_chu = 0.00000000000000000001
    return (1 / re_chu) * exponent


def calculateClassProbabilities(summaries, inputVector):
    probabilities = {}
    for classValue, classSummaries in summaries.iteritems():
        probabilities[classValue] = 1
        for i in range(len(classSummaries)):
            mean, stdev = classSummaries[i]
            x = inputVector[i]
            probabilities[classValue] *= calculateProbability(x, mean, stdev)
    return probabilities


def predict(summaries, inputVector):
    probabilities = calculateClassProbabilities(summaries, inputVector)
    bestLabel, bestProb = None, -1
    for classValue, probability in probabilities.iteritems():
        if abs(probability - bestProb) < 0.1:
            # print probability, bestProb
            return "maybe"

        if bestLabel is None or probability > bestProb:
            bestProb = probability
            bestLabel = classValue

    return bestLabel


def getPredictions(summaries, testSet):
    predictions = []
    maybe = 0
    for i in range(len(testSet)):
        result = predict(summaries, testSet[i])
        predictions.append(result)
        if result == 'maybe':
            maybe += 1
    return predictions, maybe


def getAccuracy(test_name, predictions, is_maybe=None):
    correct = 0
    for i in range(len(predictions)):
        if test_name == predictions[i] or (is_maybe is not None and test_name == "maybe"):
            correct += 1
    return (correct / float(len(predictions))) * 100.0


def parse_sql(raw_sql):
    parsed_sql = []
    sql = sqlparse.parse(raw_sql)
    for parse in sql:
        for token in parse.tokens:
            if token._get_repr_name() != 'Whitespace':
                parsed_sql.append(token._get_repr_name())
    return parsed_sql


class Check():
    def __init__(self):
        in_put = open('sql_shibie/matrix_bad.js', 'r')
        bad = in_put.readline()
        in_put.close()

        in_put = open('sql_shibie/matrix_good.js', 'r')
        good = in_put.readline()
        in_put.close()

        in_put = open('sql_shibie/allMap.js', 'r')
        self.allMap = in_put.readline()
        in_put.close()

        self.allMap = json.loads(self.allMap)

        bad, bad_test = splitDataset(json.loads(bad), 0.9)
        good, good_test = splitDataset(json.loads(good), 0.9)
        self.summaries = {'bad': summarize(bad), 'good': summarize(good)}

        self.all_inject = self.read_all("sql_shibie/data")

    def read_all(self, basedir):

        df_list = []
        filelist = os.listdir(basedir)
        # 循环读取 basedir下面的内容，文件名为 'legit'的是合法内容，malicious的是 恶意sql语句
        for file in filelist:
            i = 0
            input = open(basedir + '/' + file)
            for line in input.readlines():
                line = line.replace("\n", "")
                df_list.append(line)
        return df_list

    def searching(self, sql):
        print sql
        for li in self.all_inject:
            # print li
            if li in sql and li != '':
                return False
        return True


    def check_one(self, sql):
        print "sql: ", sql
        sql = sql.encode('utf-8').decode("utf-8")
        print "sql-p: ", sql
        # print sql
        sql_P = parse_sql(sql)
        list = [0] * (len(self.allMap))
        for li in sql_P:
            if li in self.allMap:
                list[self.allMap[li] - 1] += 1
        list[-1] = len(sql_P)
        result = predict(self.summaries, list)

        if result == "good" and self.searching(sql):
            return True
        else:
            return False


def main():
    in_put = open('matrix_bad.js', 'r')
    bad = in_put.readline()
    in_put.close()

    in_put = open('matrix_good.js', 'r')
    good = in_put.readline()
    in_put.close()

    in_put = open('allMap.js', 'r')
    allMap = in_put.readline()
    in_put.close()

    allMap = json.loads(allMap)

    bad, bad_test = splitDataset(json.loads(bad), 0.7)
    good, good_test = splitDataset(json.loads(good), 0.7)
    summaries = {}
    summaries['bad'] = summarize(bad)
    summaries['good'] = summarize(good)

    stop = time()
    print json.dumps(summaries)
    # 开始单一预测

    start = time()
    sql = parse_sql("1 and 1=1")
    print sql
    list = [0] * (len(allMap))

    for li in sql:
        if li in allMap:
            list[allMap[li] - 1] += 1
    list[-1] = len(sql)
    result = predict(summaries, list)
    print result

    print "用了", (stop - start), "秒"

    predictions, maybe = getPredictions(summaries, good_test)
    accuracy = getAccuracy("good", predictions)
    zhanbi = (maybe + 0.0) / len(good_test) * 100
    print "good:", accuracy, "%", "maybe:", maybe, "sum:", len(good_test), "zhanbi:", zhanbi, "%"

    predictions, maybe = getPredictions(summaries, bad_test)
    accuracy = getAccuracy("bad", predictions)
    zhanbi = (maybe + 0.0) / len(bad_test) * 100

    print "bad:", accuracy, "%", "maybe:", maybe, "sum:", len(bad_test), "zhanbi:", zhanbi, "%"


    # test model
    # predictions = getPredictions(summaries, testSet)
    # print 'predictions', predictions
    # accuracy = getAccuracy(testSet, predictions)
    # print('Accuracy: {0}%').format(accuracy)


if __name__ == '__main__':
    main()
    #check = Check()

    #check.check_one("1 and 1=1")