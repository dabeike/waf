/**
 * Created by cyh on 2015/6/4.
 */
var spawn = require('child_process').spawn,
    child1,child2,child3;

child1 = spawn('node',['http-proxy.js'],{"cwd":"src"});
child1.stdout.on('data', function(data) {
    console.log(""+data);
});
child1.on('exit', function(code) {
    if (code != 0) {
        console.log("error:"+code);
    }
});

child2 = spawn('node',['index.js'],{"cwd":"src/admin"});
child2.stdout.on('data', function(data) {
    console.log(""+data);
});
child2.on('exit', function(code) {
    if (code != 0) {
        console.log("error:"+code);
    }
});


child3 = spawn('python',['SQLinjection.py'],{"cwd":"src/inject/sqlparse"});
child3.stdout.on('data', function(data) {
    console.log(""+data);
});
child3.on('exit', function(code) {
    if (code != 0) {
        console.log("error:"+code);
    }
});
