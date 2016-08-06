# 基于NodeJS的web应用防火墙（waf）

------

兼顾前端和服务器端的waf，能有效抵御SQL注入攻击以及目录遍历攻击。创新点在于前端防火墙的设计及实现。

当前实现了：
> * 基于NodeJS的代理服务器
> * 前端防火墙实现（javascript） by friday
> * SQL注入过滤（NodeJS） by cyh

正在进行中：
> * 敏感信息注释防护 （监测脚本中是否存在敏感内容） 
> * 目录遍历漏洞防护

目标：
> * GetShell防护 （仅针对PHP）

> * CC攻击防护（待定）

如果你对我们的项目感兴趣，可以联系649321688@qq.com

**参考资料：**  

EtherDream博客：http://www.cnblogs.com/index-html/  

某git：http://git.oschina.net/bilxio/nodejs-http-proxy/

