# coding:utf8
import json
import random
import socket
import threading
from time import time, sleep
import requests
from threadpool import ThreadPool
from threadpool import WorkRequest

__author__ = 'cyh'
portnum = 10
bingfa = 10
alltime = []

def threads(i):
    start = time()
    sock = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
    while True:
        try:
            sock.connect(('127.0.0.1', 10010 + int(i % portnum)))
            sock.sendall({"ip": "::ffff:127.0.0.1", "data": {"/hello?a": "123"}, "url": "/hello?a=123", "type": 0})
            sock.recv(8192)
            break
        except Exception:
            print 'error', int(i % portnum)
            i = random.random() * portnum

    # print sock.recv(1024)
    end = time()
    # lock.acquire()
    # print '花了', end - start
    # lock.release()
    alltime.append(end - start)


def printdata(alltime):
    min = 20
    max = 0
    for li in alltime:
        # print li
        if li > max:
            max = li
        if li < min:
            min = li

    print 'max:', max, 'min', min
    print len(alltime)


def bfTest():
    pool = ThreadPool(100)
    for j in range(100):
        alltime = []
        for i in range(bingfa):
            work = WorkRequest(threads, args=(int(random.random() * portnum) % portnum,))
            pool.putRequest(work)
            sleep((1.0 / bingfa) * random.random())
            # threading.Thread(target=threads, args=(i % portnum,)).start()
        pool.wait()
        printdata(alltime)


def print_res(type, text):
    if u'已被拦截' in text:
        print type, ": ", "已拦截"
    else:
        print type, ": ", '正常显示'


def allTest(url):
    badparmas = open('sql_shibie/test_bad', 'r')
    goodparmas = open('sql_shibie/test_good', 'r')
    print 'bad test begin'
    for badparma in badparmas:
        res = requests.post(url=url, data={"a": badparma, "b": badparma})
        print_res('post', res.text)
        res = requests.get(url, params={"a": badparma, "b": badparma})
        print_res('get', res.text)

    print 'good test begin'
    for goodparma in goodparmas:
        res = requests.get(url, params={"a": goodparma, "b": goodparma})
        print_res('get', res.text)
        res = requests.post(url, data={"a": goodparma, "b": goodparma})
        print_res('post', res.text)


if __name__ == '__main__':
    allTest('http://127.0.0.1/hello')





