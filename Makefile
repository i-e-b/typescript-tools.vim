TSC=node ../typescript/bin/tsc.js
TEST_SCRIPTS=tests/*.script
TEST_SOURCES=tests/*.ts
VERSION=$(shell git describe --tags)

build: bin/tss.js tests/script.out2 package.json

bin/tss.js: tss.ts harness.ts
	$(TSC) tss.ts -target es5 -out bin/tss.js 2>&1 | tee build.log

tests/script.out2: $(TEST_SCRIPTS) $(TEST_SOURCES) tests/script.js tests/script.out bin/tss.js
	cd tests;\
	node script.js >script.out2;\
	diff --strip-trailing-cr script.out*

package.json: .git/refs/heads/master
	node -e "var pj=require('./package.json'); \
					 pj.version='$(VERSION)';\
					 require('fs').writeFileSync('package.json',JSON.stringify(pj,null,'  '));"