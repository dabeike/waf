'use strict';

var express = require('express');
var mysql = require('mysql');
var swig  = require('swig');
var basicAuth = require('basic-auth');
var bodyParser = require('body-parser');

var crypto = require('crypto');


var fs=require('fs');                                //读取文件
var ConfigData = JSON.parse(fs.readFileSync('config/config.json')); //读取配置文件

var app = express();
app.use(express.static(__dirname+'/public'));   //设置静态目录
app.use(bodyParser.urlencoded({ extended: false }));         //post-data parser

var pool = mysql.createPool({
	host		:	'localhost',
	port		: 	3306,
	database	: 	'waf',
	user		: 	'root',
	password	: 	''
});

var auth = function (req, res, next) {
    function unauthorized(res) {
        res.set('WWW-Authenticate', 'Basic realm=Authorization Required');
        return res.send(401);
    }

    var user = basicAuth(req);

    if (!user || !user.name || !user.pass) {
        return unauthorized(res);
    }

    if (user.name === 'root' && user.pass === 'root') {
        return next();
    } else {
        return unauthorized(res);
    }
};

app.get('/index.html', auth, function(req, res){
    pool.query('select count(*) as num,date_format(time,\'%Y-%m-%d\') as date from xss_log group by date order by date desc limit 30', {}, function (error, response){
        if(error){
            res.send('获取XSS数据失败');
        }
        else{
            pool.query('select count(*) as num,date_format(time,\'%Y-%m-%d\') as date from sql_log group by date order by date desc limit 30',{},function(sql_error,sql_response){
                if(sql_error){
                    res.send('获取SQL数据失败');
                }
                else{
                    pool.query('select sum(count) from xss_log union select sum(count) from sql_log',{},function(xss_sum_error,sum){
                        res.send(swig.renderFile('./template/index.html', {
                            xss_data: response,
                            sql_data: sql_response,
                            times_xss:sum[0]['sum(count)'],
                            times_sql_inject:sum[1]['sum(count)'],
                            nav_statu:0
                        })); 
                    })
                    
                }
            });
        }
    });
});

app.get('/xss.html', auth, function(req, res){
    pool.query('select * from xss_log where statu = 0;',{},function(error,response){
        if(error){
            res.send("数据库连接失败_1")
        }
        else{
            for(var x in response){
                for (var y in response[x]){
                    if(typeof response[x][y] == typeof '123' && response[x][y].length > 200 )
                        response[x][y] = response[x][y].substring(0,200)+' ...'
                }
            }
            res.send(swig.renderFile('./template/xss.html', {
                data: response,
                xss_config:ConfigData['xss'],
                nav_statu:1
            }));
        }
    });
});

app.get('/xss_log/:error_code/:url/:code_xss_area/:payload/:cookie?',function(req,res){
    var str;
    var obj = req.params;
    var shasum=crypto.createHash('sha1');
    var all_data={
        error_code:obj.error_code,
        url:obj.url,
        code_xss_area:obj.code_xss_area,
        payload:obj.payload,
        cookie:obj.cookie ,
        ip:req.connection.remoteAddress
    };

    shasum.update(JSON.stringify(all_data));
    var d = ""+shasum.digest('hex');
    console.log(d);
    all_data.token=d;
    console.log(JSON.stringify(all_data));

    pool.query('select * from xss_log where ?',{token:d},function(error,response){
        if(error){
            console.log(error)
        }
        else{
            console.log(response.length);
            var sql;
            if(response.length>0){
                all_data=response[0];
                all_data.count+=1;
                console.log("find:"+response[0].id);
                sql='update xss_log set ? where id='+response[0].id
            }
            else{
                all_data.count=1;
                sql='insert into xss_log set ?';
            }
            pool.query(sql,all_data,
                function(error,response){
                    if(error){
                        str = {"code": -1, "msg": '插入数据失败'}
                        console.log(error)
                    }
                    else {
                        str = {"code": 1, "msg": '插入数据成功'}
                    }
                    res.setHeader('Content-Type', 'text/javascript');
                    res.send('callback('+JSON.stringify(str)+')');
                });

        }
    });
});

app.get('/xss_detail/:id',auth,function(req,res){
    pool.query('select * from xss_log where ?',{id:req.params.id},function(error,response){
        if(error){
            console.log(error)
        }
        else{
            res.send(swig.renderFile('./template/xss_detail.html', {
                data: response[0],
                nav_statu:2
            }));
        }
    });
});

app.get('/log_all/:type',auth,function(req,res){
    if(req.params.type == 'xss'){
        pool.query('select * from xss_log',{},function(error,response){
            if(error){
                console.log(error)
            }
            else{
                for(var x in response){
                    for (var y in response[x]){
                        if(typeof response[x][y] == typeof '123' && response[x][y].length > 200 )
                            response[x][y] = response[x][y].substring(0,200)+' ...'
                    }
                }
                res.send(swig.renderFile('./template/log_all.html', {
                    data: response,
                    nav_statu:2
                }));
            }
        })
    }
    else{
        pool.query('select * from sql_log',{},function(error,response){
            if(error){
                console.log(error)
            }
            else{
                for(var x in response){
                    for (var y in response[x]){
                        if(typeof response[x][y] == typeof '123' && response[x][y].length > 200 )
                            response[x][y] = response[x][y].substring(0,200)+' ...'
                    }
                }
                res.send(swig.renderFile('./template/log_all.html', {
                    data: response,
                    nav_statu:3
                }));
            }
        })
    }
});

app.post('/xss_statu',auth, function(req,res) { //statu=1 我知道了 statu=2 误报
    pool.query('update xss_log set statu='+req.body.statu+' where id in '+req.body.str, {}, function (error, response) {
        if(error){
            res.send('获取数据失败');
        }
        else{
            var str = {"rows":response.changedRows}
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify(str));
        }
    });
});

app.post('/list_add',auth, function(req,res) {
    var type_code = {"1":"white_url","2":"black_url","3":"white_iframe"};
    ConfigData['xss']['list'][type_code[req.body.type]].push(req.body.content);

    fs.writeFile('config/config.json',JSON.stringify(ConfigData),function(error){
        var str;
        if(error){
            throw("配置写入文件失败！");
        }

        str = {"code":1, "msg":"配置写入成功，请重启进程！"};
        res.setHeader('Content-Type', 'application/json');
        res.send(JSON.stringify(str));
    });
});

app.post('/list_del',auth, function(req,res) {
    var type_code = {"1":"white_url","2":"black_url","3":"white_iframe"};
    ConfigData['xss']['list'][type_code[req.body.type]].splice(req.body.id,1);

    fs.writeFile('config/config.json',JSON.stringify(ConfigData),function(error){
        var str;
        if(error){
            throw("配置写入文件失败！");
        }

        str = {"code":1, "msg":"配置写入成功，请重启进程！"};
        res.setHeader('Content-Type', 'application/json');
        res.send(JSON.stringify(str));
    });
});

app.post('/xss_config', auth, function(req,res){
    for(var x in req.body){     //转换为数字型（布尔）
        req.body[x] = parseInt(req.body[x])
    }
    ConfigData['xss']['basic'] = req.body;

    fs.writeFile('config/config.json',JSON.stringify(ConfigData),function(error){
        var str;
        if(error){
            throw("配置写入文件失败！");
        }

        str = {"code":1, "msg":"配置写入成功，请重启进程！"};
        res.setHeader('Content-Type', 'application/json');
        res.send(JSON.stringify(str));
    });

});

//sql注入部分
app.get('/sql_inject.html', auth, function(req, res){
    pool.query('select * from sql_log where statu = 0;',{},function(error,response){
        if(error){
            res.send("数据库连接失败_1")
        }
        else{
            for(var x in response){
                for (var y in response[x]){
                    if(typeof response[x][y] == typeof '123' && response[x][y].length > 200 )
                        response[x][y] = response[x][y].substring(0,200)+' ...'
                }
            }
            res.send(swig.renderFile('./template/sql_inject.html', {
                data: response,
                sql_config:ConfigData['sql'],
                nav_statu:2
            }));
        }
    });

});

app.post('/sql_log', function(req,res) {
    var params = req.body;
    var str;
    var shasum=crypto.createHash('sha1');
    var all_data={
        "url":params.url,
        "type":params.type,
        "data":params.data,
        "is_bad":params.is_bad,
        "bad_key":params.bad_key,
        "ip":params.ip,
        "statu":0
    };

    shasum.update(JSON.stringify(all_data));
    var d = ""+shasum.digest('hex');
    console.log(d);
    all_data.token=d;
    console.log(JSON.stringify(all_data));

    pool.query('select * from sql_log where ?',{token:d},function(error,response){
        if(error){
            console.log(error)
        }
        else{
            console.log(response.length);
            var sql;
            if(response.length>0){
                all_data=response[0];
                all_data.count+=1;
                console.log("find:"+response[0].id);
                sql='update sql_log set ? where id='+response[0].id
            }
            else{
                all_data.count=1;
                sql='insert into sql_log set ?';
            }
            pool.query(sql,all_data,
                function(error,response){
                    if(error){
                        str = {"code": -1, "msg": '插入数据失败'}
                        console.log(error)
                    }
                    else {
                        str = {"code": 1, "msg": '插入数据成功'}
                    }
                    res.setHeader('Content-Type', 'text/javascript');
                    res.send('callback('+JSON.stringify(str)+')');
                });
        }
    });

});

app.get('/sql_detail/:id', auth, function(req,res){
    pool.query('select * from sql_log where ?',{id:req.params.id},function(error,response){
        if(error){
            console.log(error)
        }
        else{
            res.send(swig.renderFile('./template/sql_detail.html', {
                data: response[0],
                nav_statu:3
            }));
        }
    });
});

app.post('/sql_statu', auth, function(req, res){
    pool.query('update sql_log set ? where ?',
        [{statu:req.body.statu},{id:req.body.str}], function (error, response) {
        if(error){
            res.send('获取数据失败');
        }
        else{
            var str = {"rows":response.changedRows};
            res.setHeader('Content-Type', 'application/json');
            res.send(JSON.stringify(str));
        }
    });
});

app.post('/sql_config', auth, function(req, res){
    for(var x in req.body){     //转换为数字型（布尔）
        if(x!="local_ip")
            req.body[x] = parseInt(req.body[x]);
    }
    var data=req.body;
    data.per_port_thread=data.per_port_num;
    console.log(data);
    ConfigData['sql']['basic'] = req.body;

    fs.writeFile('config/config.json',JSON.stringify(ConfigData),function(error){
        var str;
        if(error){
            throw("配置写入文件失败！");
        }

        str = {"code":1, "msg":"配置写入成功，请重启进程！"};
        res.setHeader('Content-Type', 'application/json');
        res.send(JSON.stringify(str));
    });
});



app.listen(1337, '127.0.0.1');
console.log('running in port:'+1337);