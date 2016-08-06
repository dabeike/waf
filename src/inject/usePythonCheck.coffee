net = require("net");
fs=require('fs');
deepCopy=(o)->
    return JSON.parse(JSON.stringify(o));
#设置参数
options={
    port:10000,
    host:'127.0.0.1'
}
port_num=10

#读配置文件
config=JSON.parse(fs.readFileSync('./admin/config/config.json'));
options.host=config.sql.local_ip
options.port=config.sql.start_port
port_num=config.sql.port_num

# 全局变量
lits=[]
iport=0

connect_ok_test=(i)->
    ->
        this.write(JSON.stringify({
            d:"aaa"
        }))
        console.log('bi:'+i)

count=0
work=(i)->
    option=deepCopy(options)
    option.port+=i
    client = net.connect(option,connect_ok_test(i))

    client.on('data',(data)->
        console.log(data.toString())
        count+=1
        this.end()
        this.destroy()
        console.timeEnd('lable')
    )
    client.on('error',(e)->
        console.log(count+e.code+i)
        work(i)
    )

start_test=()->
    for j in [0..10]
        for i in [0...100]
            console.log(i)
            work(i)
    console.time('lable')




connect_ok=(data)->
    ->
        console.log(data)
        this.write(JSON.stringify(data))

get_res=(callback)->
    (res)->
        this.end()
        callback(res.toString())

error=(data)->
    (e)->
        console.log(e.code)
        check(data)

check=(data,callback)->
    option=deepCopy(options)
    iport++
    option.port+=iport%port_num #Todo:
    console.log(option)
    client = net.connect(option,connect_ok(data))
    client.on('data',get_res(callback))
    client.on('error',error(data))


#start_test()
callit_test=(res)->
    console.log(res.toString())

ii={
    'd':'aaa'
}
# check(ii,callit)

exports.check=check