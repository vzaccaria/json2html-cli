# Makefile autogenerated by Dyi on July 1, 2015
#
# Main target: all
# Sources:  command.ls  parse.ls 

.DEFAULT_GOAL := all


.PHONY: c-3t5vffg3
c-3t5vffg3: command.js parse.js


.PHONY: build
build: c-3t5vffg3


.PHONY: test
test: k-0oma6i6n


.PHONY: up
up: k-jl3t0jdj


.PHONY: major
major: k-hyk04hes


.PHONY: minor
minor: k-7rd1613v


.PHONY: patch
patch: k-uywa5gji


.PHONY: prepare
prepare: .




.PHONY: k-a4dqh4gh
k-a4dqh4gh:  
	((echo '#!/usr/bin/env node') && cat command.js) > index.js


.PHONY: k-8smq1p83
k-8smq1p83:  
	chmod +x ./index.js


.PHONY: all
all: 
	make build 
	make k-a4dqh4gh 
	make k-8smq1p83  


.PHONY: k-0oma6i6n
k-0oma6i6n:  
	./test/test.sh


.PHONY: k-jl3t0jdj
k-jl3t0jdj:  
	make clean && babel configure.js | node


.PHONY: k-hyk04hes
k-hyk04hes:  
	./node_modules/.bin/xyz -i major


.PHONY: k-7rd1613v
k-7rd1613v:  
	./node_modules/.bin/xyz -i minor


.PHONY: k-uywa5gji
k-uywa5gji:  
	./node_modules/.bin/xyz -i patch


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

