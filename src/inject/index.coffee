proxy=require('../http-proxy')
parse_get = require("url");                     # 解析GET请求
parse_post = require("querystring");            # 解析POST请求
http = require('http');
inject = require("./usePythonCheck");

check_words=(data)->
    flag=true
    for li,dat of data
        if(/xss/.test(dat))
            flag=false
            break
        console.log(li,dat)
    flag

check_inject=(data,response,headers,url,post)->
    (res)->

        flag=false
        console.log(res)
        if res=='true'and check_words(data)
            flag=true
        else
            flag=false

        if flag
            proxy.httpRequest(response,headers,url,post)
        else
            body='<html><head><meta charset="utf-8"></head><body>您的请求含有攻击信息，已被拦截</body></html>'
            response.writeHead(404,{
                'Content-Type': 'text/html;charset=utf-8',
            })
            response.write(body)
            response.end()

filter=(request,response,headers,url,post,type)->
    if(post)
        console.log("post:"+post)
        data=parse_post.parse(post)
        console.log(data)
    else
        console.log("get:"+url)
        data=parse_get.parse(url,true).query


    inject.check({
            ip:request.connection.remoteAddress
            data:data,
            url:url,
            type:type
        }

    ,check_inject(data,response,headers,url,post))





exports.filter=filter