'use strict';

var http = require('http');
var parseurl = require("url");                       //解析GET请求  
var querystring = require("querystring");            //解析POST请求
var fs=require('fs');                                //读取文件
var inject=require("./inject");
var swig  = require('swig');                        //模板引擎，用于往前端防火墙填写配置文件

var frontWafFile='xss/front-waf.js';
var ConfigData = JSON.parse(fs.readFileSync('admin/config/config.json'));

var outSidePort=80;         //外部开放端口80
var inSidePort=8080;        //内部交互端口8080

var isOpenInjectWaf=ConfigData['sql']['basic']['is_open'];
http.createServer(httpHandler).listen(outSidePort);
console.log('listening at '+outSidePort);

function httpHandler(request, response){
	var headers = request.headers,post = '',url = request.url;
    console.log(url);

	if(request.method == 'POST'){
		request.on('data', function(chunk){
			post += chunk;
		});
		request.on('end', function(){
            if(isOpenInjectWaf)inject.filter(request,response,headers,url,post,1);
            else httpRequest(response,headers,url,post)
		});
	}
	else{
        //console.log(url);
        if(isOpenInjectWaf)inject.filter(request,response,headers,url,post,0);
        else httpRequest(response,headers,url,post)
	}
}

function httpRequest(mainRes, headers, url, post){
    console.log("method?? "+(post ? 'POST' : 'GET'));
	var host = headers.host;
	var options = {
		host : host.split(':')[0],
		port : inSidePort,
		path : url,
		method : (post ? 'POST' : 'GET'),
		headers : headers
	};
	delete options.headers['accept-encoding'];

    var res=Response(mainRes);
	var request = http.request(options,res.SetResponse);	//向服务器发出请求
    console.log("option:"+JSON.stringify(options));
	//如果是post方式，要向请求中写入post数据
	if(post){
        console.log("if post:"+post);
		request.write(post);
        console.log("if post-str:"+querystring.stringify(post));
	}
	request.end();
	request.on('error', function(e){
		console.log('SOCKET-ERROR: ' + e.message);
	});
}

/*
* @todo 添加脚本位置修改，使用正则表达式匹配</head>或者有charset的meta标签
*/

function Response(init_response){
    var pub={
        response:init_response,

        //proxy请求服务器后的回调函数,完善mainRes(实际返回给客户端的response)
        SetResponse:function (res){
            var status = res.statusCode,
                headers = res.headers,
                data = '';

            delete(headers['content-length'])
            pub.response.writeHead(status, headers);

            //设置编码
            var encoding = 'utf8';
            if(headers['content-type'] && (headers['content-type'].indexOf('image') >= 0
                || headers['content-type'].indexOf('application') >= 0
                || headers['content-type'].indexOf('audio') >= 0
                || headers['content-type'].indexOf('video') >= 0)){
                encoding = 'binary';
            }
            res.setEncoding(encoding);

            //写数据
            var ScriptWrite=0;
            res.on('data', function(d){
                if(!ScriptWrite && headers['content-type'] && headers['content-type'].indexOf('text/html') >= 0){
                    pub.response.write("<meta charset=utf-8><script id='waf_script'>");
                    pub.response.write(swig.renderFile(frontWafFile, {"config":ConfigData['xss']}));
                    pub.response.write("</script>");
                    ScriptWrite = 1;
                }
                var b = new Buffer(d, encoding);
                pub.response.write(b)
            });
            res.on('end', function(){
                pub.response.end();
            });
        }
    };
    return pub;
}

exports.Response=Response;
exports.httpRequest=httpRequest;