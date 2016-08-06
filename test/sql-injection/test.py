# encoding:utf-8
import requests


def print_res(type, text):
    if u'已被拦截' in text:
        print type, ": ", 'Intercept'
    else:
        print type, ": ", 'Normal Pass'


def allTest(url):
    badparmas = open('test_bad', 'r')
    goodparmas = open('test_good', 'r')
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





