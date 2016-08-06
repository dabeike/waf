TESTS = test/unit/*.js
REPORTER = spec
install:
	@npm install .
	@./node_modules/pegjs/bin/pegjs peg/sqlparser.pegjs ./lib/parse.js
test: clean install
	@npm install
	@./node_modules/mocha/bin/mocha -r should  $(TESTS) --reporter spec

clean:

.PHONY: test
