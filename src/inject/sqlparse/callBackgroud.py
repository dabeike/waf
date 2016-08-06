import json
import time

__author__ = 'cyh'

url = "http://127.0.0.1/aaa"

type = "POST"

data = {
    "username": "root",
    "password": "123456' or 1='1"
}
isbad = True
badkey = {
    "password": "123456' or 1='1"
}
time0 = time.time()

reDict = {
    'url': url,
    'type': type,
    'data': data,
    'isbad': isbad,
    'badkey': badkey,
    'time': time0*1000
}

print json.dumps(reDict)