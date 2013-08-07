version := $(shell grep "^version" metadata.rb | sed -E 's/[a-z ]+"(.+)"/\1/g')

metadata.json:
	 knife cookbook metadata from file metadata.rb

chef-zookeeper-$(version).tgz:
	@git archive --format tgz -o chef-zookeeper-$(version).tgz --prefix zookeeper/ master

.PHONY=build clean

build: chef-zookeeper-$(version).tgz

clean:
	@rm chef-zookeeper-*.tgz
