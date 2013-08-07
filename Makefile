version := $(shell grep "^version" metadata.rb | sed -E 's/[a-z ]+"(.+)"/\1/g')

metadata.json:
	 @knife cookbook metadata from file metadata.rb

chef-zookeeper-$(version).tgz: metadata.json
	@git archive --format tgz -o chef-zookeeper-$(version).tgz --prefix zookeeper/ master

.PHONY=build clean

build: chef-zookeeper-$(version).tgz

clean:
	@rm -f chef-zookeeper-*.tgz
	@rm -f metadata.json

pre-commit: clean metadata.json
	@git add metadata.json
