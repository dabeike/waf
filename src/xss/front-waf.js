(function(){
    var debug = {{ config['basic']['is_debug'] }};
    var OutsiteWhiteList = ["127.0.0.1:1337",{% for value in config.list.white_url %}"{{ value }}", {% endfor %}];  //跨站脚本白名单，包括百度分享，google统计等
    var OutsiteBlackList = [{% for value in config.list.black_url %}"{{ value }}", {% endfor %}];
    var IframeWhiteList  = [{% for value in config.list.white_iframe %}"{{ value }}", {% endfor %}];
    var ErrorCodeType    = {
        {% for key,value in config.error_code %}"{{ key }}":"{{ value }}", {% endfor %}
    };    //对象模拟数组，拦截的脚本类型
    var EvalRewrite = {{ config['basic']['eval_rewrite'] }};
    var ScriptProtect = {{ config['basic']['script_protect']}};
    var IframeProtect = {{ config['basic']['iframe_protect'] }};

    /** 正则表达式生成函数
     ** @input : keyword 数组形式，如['xss','x ss']
     ** @output: 格式化的正则表达式，如(xss|x ss)
     **/
    function get_reg(keyword){
        var str='(';
        for(var i in keyword){
            str+=keyword[i]+"|";
        }

        return str.length>1?str.slice(0,-1)+')':false;
    }

    /** AJAX GET
     ** @input : url - 所要获取的URL地址
     ** @input : return_func - 回调函数
     ** @output: 无
     **/
    var ajax_get=function(url,return_func){
        var xmlhttp=createxmlhttp();
        xmlhttp.open("GET",url,true);
        xmlhttp.send();

        xmlhttp.onreadystatechange=function(){
            if(xmlhttp.readyState==4){
                return_func(xmlhttp.status,xmlhttp.responseText);
            }
        }

        function createxmlhttp(){
            return (window.XMLHttpRequest)?new XMLHttpRequest():new ActiveXObject("Microsoft.XMLHTTP");
        }
    } 

    /** jsonp回调函数
     ** input : result - 服务器返回结果
     **/
    window.callback = function(result){
        if(!result.code){
            console.error('预警信息插入失败!');
        }
    };

    /** xss预警函数 - 向服务器发出预警，并调用回调函数
     ** @input : error_code 错误代码， code_xss_area xss部分的代码（便于漏洞定位）， payload xss的攻击代码或远程脚本的src
     ** @output: none
     **/
    function xss_notice(error_code,code_xss_area,payload){
        var url = window.location.href
        var target_url = 'http://127.0.0.1:1337/xss_log/'+error_code+'/'+encodeURIComponent(url)+'/'+(encodeURIComponent(code_xss_area)+'null')+'/'+(encodeURIComponent(payload)|'null')+'/'+(document.cookie|'null');
        var test = document.createElement('script');
        test.src = target_url;
        document.body.appendChild(test);

        if(debug){
            console.warn('【DEBUG】拦截/监听到'+ErrorCodeType[error_code])
        }
    }

    /** xss检测函数
     ** @input : code-代码内容
     ** @output: true-检测到XSS,false-未检测到XSS
     ** @TODo  : 完善keyword,增加&#x000000078;&#x000000073;&#x000000073;等畸形格式的检测
     **/
    function xss_test(code){
        var keyword=['xss','eHNz','&#120;&#115;&#115;','&#x78;&#x73;&#x73;','\\u0078\\u0073\\u0073',
            '\\x78\\x73\\x73','\\170\\163\\163','data:text/html',/*特殊格式XSS*/
            'alert\\\(\\s*\\d+\\\)','alert\\\(test\\\)','hacked',/*匹配alert(1),alert(test)*/
            'String.fromCharCode','document.cookie','(\\\[\\\].*){3,}',];
        
        var pattern=new RegExp(get_reg(keyword),"i");
        if(pattern.test(code)){
            return true;
        }

        return false;
    }

    /** 跨站脚本合法检测函数
     ** @input : script_src-跨站脚本的地址
     ** @output: ‘white_list’-当前URL在白名单中,'black_list'-黑名单，'url_word'-检测到URL关键字，false本步未检测到危害，需要进一步测试
     **/
    function url_test(script_src){
        var script_host=script_src.match(/(http:\/\/|https:\/\/)?([^\/]*)/)[2]; //script对应的host
        
        //检测黑名单
        if(reg_test(OutsiteBlackList,script_host)){
            return 'black_list';
        }
        
        //检测白名单
        if(reg_test(OutsiteWhiteList,script_host)){
            return 'white_list';
        }

        //检测URL关键字
        if(xss_test(script_src)){
            return 'url_word';
        }

        return false;
    }

    /**
     ** @input : List  - 用于匹配的名单，test_ob - 被匹配的对象
     ** @output: false - 未匹配成功，true - 匹配成功
     **/
    function reg_test(List,test_ob){    
        var reg=get_reg(List);
        if(reg){
            var reg_ob=new RegExp(reg,"i");     //创建正则表达式对象
            if(reg_ob.test(test_ob)){
                return true;
            }
        }

        return false;
    }

    /** 脚本拦截/预警函数
     ** 如果删除成功，即为拦截成功，否则为预警
     ** input : node 结点， code 错误代码
     **/
    function delete_node(node,code){
        try{
            var temp = node.parentNode.removeChild(node);
            if(temp){
                xss_notice(code, "null",  node.innerHTML || node.src);
                // console.warn('【记录】拦截到'+ErrorCodeType[code]+'['+code+']: ',node);
            }
        }
        catch(e){
            xss_notice(code, "null", node.innerHTML || node.src);
            // console.warn('【记录】监听到'+ErrorCodeType[code]+'['+code+']: ',node);
        }
    }

    if(ScriptProtect) {
        /**
         ** 内联脚本检测 - 在dom元素加载完之后，开始扫描document的所有事件，并绑定listener
         **/
        var mCheckMap = {};     //存储已扫描过的事件
        var mCheckID = 0;

        function hookEvent(eventName, eventID) {
            document.addEventListener(eventName.substr(2), function (e) {
                scanElement(e.target);
            }, true);


            function scanElement(el) {
                // 跳过已扫描的事件
                var flag = el['_k'];
                if (!flag) {
                    flag = el['_k'] = ++mCheckID;
                }

                var hash = (flag << 8) | eventID;
                if (hash in mCheckMap) {
                    return;
                }
                mCheckMap[hash] = true;

                // 非元素节点
                if (el.nodeType != Node.ELEMENT_NODE) {
                    return;
                }

                // 扫描内联代码
                if (el[eventName]) {
                    var code = el.getAttribute(eventName);
                    if (code && xss_test(code)) {
                        xss_notice(101, el.parentNode.innerHTML, code);
                        el[eventName] = null;
                    }
                }

                // 扫描 <a href="javascript:"> || <a xlink:href="javascript:"></a>的脚本
                if (eventName == 'onclick' && el.tagName == 'A') {
                    if (el.getAttribute('xlink:href') && xss_test(el.getAttribute('xlink:href'))) {
                        xss_notice(102, el.parentNode.innerHTML, el.getAttribute('xlink:href'));
                        el.setAttribute("xlink:href", "javascript:void");
                    }
                    if (el.href && xss_test(el.href)) {
                        xss_notice(102, el.parentNode.innerHTML, el.href);
                        el.href = 'javascript:void(0)';
                    }
                }

                // 扫描上级元素
                scanElement(el.parentNode);
            }
        }

        document.onreadystatechange = function () {
            var i = 0;
            for (var k in document) {
                if (/^on./.test(k)) {
                    hookEvent(k, i++);
                }
            }
        };


        /**
         ** Mutation监听函数 - 监听并拦截静态脚本（FireFox不可拦截）以及监听外站动态脚本
         ** 静态脚本指：页面中原本就有的元素，不是通过脚本动态创建的
         **/
        var MutationObserver = window.MutationObserver || window.WebKitMutationObserver || window.MozMutationObserver;
        var observer = new MutationObserver(function (mutations) {
            mutations.forEach(function (mutation) {
                var nodes = mutation.addedNodes;
                for (var i = 0; i < nodes.length; i++) {
                    var node = nodes[i];
                    if (node.tagName == 'SCRIPT') {
                        if (node.innerHTML && xss_test(node.innerHTML)) {   //静态模块一，如：\<script>alert('bb')\<\/script>
                            delete_node(node, 203);
                        }
                        //\<script src="">\<\/script>有两种可能，静态（可拦截）动态（可监听）
                        else if (node.src) {    //如果链接在黑名单中或者有XSS关键字
                            var res = url_test(node.src);
                            switch (res) {
                                case 'url_word':
                                    delete_node(node, 201);
                                    break; //URL关键字
                                case 'black_list':
                                    delete_node(node, 202);
                                    break; //黑名单
                                case 'white_list':
                                    break;  //如果是白名单，跳过接下来的文件内容检测
                                default:         //如果没有检测到危害，那么ajax获取文件内容继续检测（ajax优先级低，无法拦截）
                                    ajax_get(node.src,function(status,text){
                                        if(status==200 && xss_test(text)){
                                            delete_node(node,203,false);
                                        }
                                    });
                                    break;
                            }
                        }
                    }

                    //对于iframe，由于不常用，所以，监控所有的Iframe元素，直接用白名单过滤
                    if (node.tagName == 'IFRAME') {
                        if (node.getAttribute('srcdoc')) {    //动态添加的srcdoc 同样可以被拦截
                            delete_node(node, 401);
                        }
                        else if (node.src && !reg_test(IframeWhiteList, node.src)) {   //如果没有被白名单匹配到
                            delete_node(node, 402);
                        }
                    }
                }
            });
        });

        observer.observe(document, {
            subtree: true,
            childList: true
        });

        //重写createElement (兼容各个浏览器)
        var raw_createElement = Document.prototype.createElement;
        Document.prototype.createElement = function () {
            var element = raw_createElement.apply(this, arguments);

            // 为脚本元素安装属性钩子
            if (element.tagName == 'SCRIPT') {
                element.__defineSetter__('src', function (url) {
                    element.setAttribute("src",url)
                });
            }

            if (element.tagName == 'IFRAME') {    //不允许动态创建iframe
                /*检测到未允许的iframe，后台提醒*/
                xss_notice(403, 'null', 'null');
                return;
            }

            return element;     //createElement函数需要返回一个对象
        };

        // 重写setAttribute (兼容各个浏览器)
        var raw_setAttribute = Element.prototype.setAttribute;
        Element.prototype.setAttribute = function (name, url) {
            if (this.tagName == 'SCRIPT' && /^src$/i.test(name)) {
                var res = url_test(url);
                switch (res) {
                    case 'white_list':
                        break;
                    case 'url_word':
                        xss_notice(301, 'null', url);
                        return;
                    case 'black_list':
                        xss_notice(302, 'null', url);
                        return;
                    default:
                        ajax_get(url,function(status,text){
                            if(status==200 && xss_test(text)){
                                xss_notice(303,'null',url);
                                return;
                            }
                        });
                        break;
                }
            }
            raw_setAttribute.apply(this, arguments);  //setAttribute并不需要返回值
        };

        //重写 createElementNS

        //重写 cloneNode

        //重写 setAttributeNode

        //重写 window.open

        //重写 showModalDialog

        //重写 showModelessDialog
    }


    if(IframeProtect){
        // 添加iframe支持(给框架里环境也装个钩子)
        window.document.addEventListener('DOMNodeInserted', function(e) {
            var element = e.target;

            if (element.tagName == 'IFRAME'){
                var first_script=element.contentWindow.document.getElementsByTagName('script')[0];
                if(first_script){       //如果页面里面有script，那就添加到第一个script标签前
                    var new_node=element.contentWindow.document.createElement('script');
                    new_node.innerHTML=document.getElementById('waf_script');
                    element.contentWindow.document.insertBefore(new_node,first_script);
                }
                else{   //否则，在页面最后append
                    var new_node=element.contentWindow.document.createElement('script');
                    new_node.innerHTML=document.getElementById('waf_script').innerHTML;
                    element.contentWindow.document.head.appendChild(new_node);
                }
            }
        }, true);
    }

    //EvalRewrite
    if(EvalRewrite){
        //重写eval
        var raw_eval = eval;
        eval = function(e){
            if(xss_test(e)){
                xss_notice(501,'',e);
            }
            else{
                raw_eval(e)
            }
        };
        eval.constructor=undefined;

        //重写setTimeout
        var raw_setTimeout =setTimeout;
        setTimeout = function(func, delay){
            if(xss_test(func)){
                xss_notice(502,'',func);
            }
            else{
                raw_setTimeout(func,delay)
            }
        };
        setTimeout.constructor=undefined;

        //重写setInterval
        var raw_setInterval =setInterval;
        setInterval = function(func, delay){
            if(xss_test(func)){
                xss_notice(503,'',func);
            }
            else{
                raw_setInterval(func,delay)
            }
        };
        setInterval.constructor=undefined;
    }

})();


(function() {
    //锁死call和apply，防止盗用和重写
    Object.defineProperty(Function.prototype, 'call', {
        value: Function.prototype.call,
        writable: false,
        configurable: false,
        enumerable: true
    });
    Object.defineProperty(Function.prototype, 'apply', {
        value: Function.prototype.apply,
        writable: false,
        configurable: false,
        enumerable: true
    });
})();