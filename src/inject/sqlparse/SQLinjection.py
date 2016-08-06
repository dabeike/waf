# coding:utf8
import json
import socket
import threading
from time import sleep, time
import requests
from sql_shibie.beiyes2 import Check
from threadpool import ThreadPool, WorkRequest
import sys
reload(sys)
print sys.getdefaultencoding()
sys.setdefaultencoding('utf-8')
__author__ = 'cyh'


class checkServer():
    def __init__(self):
        self.start_port = 10000
        self.port_num = 100
        self.per_port_num = 10
        self.per_port_thread = 10
        self.max_bufer = 16384
        self.local_ip = '127.0.0.1'
        self.check = Check()

        self.log_pool = ThreadPool(self.per_port_thread)

    def setConfig(self, **kwargs):
        self.start_port = int(kwargs['start_port'])
        self.port_num = int(kwargs['port_num'])
        self.per_port_num = int(kwargs['per_port_num'])
        self.per_port_thread = int(kwargs['per_port_thread'])
        self.max_bufer = int(kwargs['max_bufer'])
        self.local_ip = kwargs['local_ip']

    def tcplink(self, con, addr):
        # print 'Accept new connection from %s:%s...' % addr
        data = ''
        r = ''
        while True:
            data = data + con.recv(self.max_bufer)
            try:
                start = time()
                js = json.loads(data)
                d = js['data']
                #################

                ###############
                flag = True
                it = {}
                for (key, value) in d.iteritems():
                    res = self.check.check_one(value)
                    flag = flag and res
                    if not flag:
                        it[key] = value
                        break
                self.post_log(js, flag, it)
                if flag:
                    con.sendall("true")
                else:
                    con.sendall("false")
                print 'send ok'
                break
            except Exception:
                continue

        end = time()
        print 'time:', end - start
        con.close()

        # print 'Connection from %s:%s closed.' % addr

    def post_log_work(self, data):
        res = requests.post(url="http://127.0.0.1:1337/sql_log", data=data)
        print res.text

    def post_log(self, allData, flag, param):
        data = {
            "ip": allData['ip'][7:],
            "url": allData['url'],
            "type": allData['type'],
            "is_bad": 0 if flag else 1,
            "bad_key": json.dumps(param),
            "data": json.dumps(allData['data']),
        }
        print json.dumps(data)

        work = WorkRequest(self.post_log_work, args=(data,))
        self.log_pool.putRequest(work)


    def setup_sock(self, i):
        sock = socket.socket(family=socket.AF_INET, type=socket.SOCK_STREAM)
        sock.bind((self.local_ip, self.start_port + i))
        sock.listen(self.per_port_num)
        pool = ThreadPool(self.per_port_thread)
        while True:
            # 接受一个新连接:
            con, addr = sock.accept()
            work = WorkRequest(self.tcplink, args=(con, addr))
            pool.putRequest(work)

        pool.wait()

    def start(self):
        pool = ThreadPool(self.port_num)
        for s in range(self.port_num):
            work = WorkRequest(self.setup_sock, args=(s,))
            pool.putRequest(work)
        print 'Start Server'
        print 'bind', self.start_port, '-', self.start_port + self.port_num, 'port'
        pool.wait()


if __name__ == '__main__':
    work = checkServer()
    f = open("../../admin/config/config.json", 'r')
    text = f.read()
    print (json.loads(text)['sql'])
    work.setConfig(**(json.loads(text)['sql']['basic']))
    work.start()
