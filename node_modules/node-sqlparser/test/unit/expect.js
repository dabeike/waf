/*!
 * node-sqlparser: test/unit/expect.js
 * Authors  : 剪巽 <jianxun.zxl@taobao.com> (https://github.com/fishbar)
 * Create   : 2014-05-21 18:05:12
 * CopyRight 2014 (c) Alibaba Group
 */
function expect(ast) {
  if (this instanceof expect) {
    this._ast = ast;
  } else {
    return new expect(ast);
  }
};

expect.prototype = {
  type: function (type) {
    this._ast.type.should.eql(type);
    return this;
  },
  columns: function (ffs) {
    var ff = {};
    ffs.forEach(function (v) {
      ff[v] = 0;
    });
    this._ast.columns.forEach(function (v) {
      var expr = v.expr;
      var key;
      switch (expr.type) {
        case 'column_ref':
          key = (expr.table ? expr.table + '.' : '') + expr.column;
          break;
        case 'aggr_func':
          key = expr.name;
          break;
      }
    });
    return this;
  },
  from: function () {
    return this;
  },
  limit: function () {
    var limit = this._ast.limit;
    var res = [];
    var args = arguments;
    var flag = true;
    limit.forEach(function (v, i) {
      var value;
      if (v.type === 'number') {
        value = parseInt(v.value, 10);
      } else {
        value = v;
      }
      if (value !== args[i]) {
        flag = false;
      }
    });
    if (!flag) {
      throw new Error('limit check failed!');
    }
    return this;
  }
}

function toStringFunc(node) {
  var key = node.name + 1;
}

module.exports = expect;