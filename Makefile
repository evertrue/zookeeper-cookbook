version := $(shell grep "^version" metadata.rb | sed -E 's/[a-z ]+"(.+)"/\1/g')

metadata.json:
	 @knife cookbook metadata from file metadata.rb

chef-zookeeper-$(version).tar:
	@git archive --format tar -o chef-zookeeper-$(version).tar --prefix zookeeper/ master

chef-zookeeper-$(version).tar.gz: metadata.json chef-zookeeper-$(version).tar
	@tar -uf chef-zookeeper-$(version).tar metadata.json
	@gzip chef-zookeeper-$(version).tar

.PHONY=build clean

build: chef-zookeeper-$(version).tar.gz

clean:
	@rm -f chef-zookeeper-*.tar.gz
	@rm -f metadata.json
