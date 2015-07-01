# Makefile autogenerated by Dyi on July 1, 2015
#
# Main target: all
# Sources:  command.ls  parse.ls 

.DEFAULT_GOAL := all


.PHONY: c-4yuwmqoo
c-4yuwmqoo: command.js parse.js


.PHONY: build
build: c-4yuwmqoo


.PHONY: test
test: k-p6b6m00x


.PHONY: up
up: k-gqjb0n3s


.PHONY: major
major: k-ehgkbt7x


.PHONY: minor
minor: k-w9ryu1gn


.PHONY: patch
patch: k-risno0un


.PHONY: docs
docs: k-8s0yyda1


.PHONY: prepare
prepare: .




.PHONY: k-u3agwt39
k-u3agwt39:  
	((echo '#!/usr/bin/env node') && cat command.js) > index.js


.PHONY: k-qpr29ryg
k-qpr29ryg:  
	chmod +x ./index.js


.PHONY: all
all: 
	make build 
	make k-u3agwt39 
	make k-qpr29ryg  


.PHONY: k-p6b6m00x
k-p6b6m00x:  
	./test/test.sh


.PHONY: k-gqjb0n3s
k-gqjb0n3s:  
	make clean && babel configure.js | node


.PHONY: k-ehgkbt7x
k-ehgkbt7x:  
	./node_modules/.bin/xyz -i major


.PHONY: k-w9ryu1gn
k-w9ryu1gn:  
	./node_modules/.bin/xyz -i minor


.PHONY: k-risno0un
k-risno0un:  
	./node_modules/.bin/xyz -i patch


.PHONY: k-8s0yyda1
k-8s0yyda1:  
	./node_modules/.bin/mustache package.json docs/readme.md | ./node_modules/.bin/stupid-replace '~USAGE~' -f docs/usage.md > readme.md


.PHONY: clean
clean:  
	rm -f command.js
	rm -f parse.js


.PHONY: update
update: 
	make clean   
	node




command.js: command.ls 
	lsc -c command.ls

parse.js: parse.ls 
	lsc -c parse.ls

.: 
	mkdir -p .

