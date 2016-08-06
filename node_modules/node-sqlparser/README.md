node-sqlparser

======

node-sqlparser, write in javascript

## Install

NodeJS Version 0.8.0+

```
npm install node-sqlparser
```

## Introduction


for the test , type the command:

```
make test
```

## Usage


static function
```js
var sql = 'select * from tablea where field1 = 0';
var parse = require('node-sqlparser').parse;
var stringify = require('node-sqlparser').stringify;
var astObj = parse(sql);

var sqlstr = stringify(astObj);
```

using ast
```
var AST = require('node-sqlparser');

var ast = new AST();
ast.parse(sql);

ast.stringify();

```

## Acknowledgements

* PegJS     : http://pegjs.majda.cz/
* NodeJS    : http://nodejs.org/
* BigQuery  : https://developers.google.com/bigquery/docs/query-reference
* PL/SQL    : http://docs.oracle.com/cd/B28359_01/appdev.111/b28370/fundamentals.htm#autoId0
* MySQL     : http://dev.mysql.com/doc/refman/5.1/en/sql-syntax.html
* Impala    : https://github.com/cloudera/impala/blob/master/fe/src/main/cup/sql-parser.y
* PgSQL     : http://www.postgresql.org/docs/9.2/interactive/sql-syntax.html
* ql.io     : http://ql.io

