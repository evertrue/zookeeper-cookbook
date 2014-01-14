version := $(shell grep "^version" metadata.rb | sed -E 's/[a-z ]+"(.+)"/\1/g')

builddir = .build
staging = $(builddir)/zookeeper

$(staging):
	@mkdir -p $(staging)

metadata.json:
	 @knife cookbook metadata from file metadata.rb

$(staging)/metadata.json: metadata.json $(staging)
	@mv metadata.json $(staging)

chef-zookeeper-$(version).tar:
	@git archive --format tar -o chef-zookeeper-$(version).tar --prefix zookeeper/ HEAD

chef-zookeeper-$(version).tar.gz: $(staging)/metadata.json chef-zookeeper-$(version).tar
	@tar -uf chef-zookeeper-$(version).tar -C $(builddir) zookeeper/metadata.json
	@gzip chef-zookeeper-$(version).tar

.PHONY=build clean

tag:
	@git tag v$(version)

build: clean chef-zookeeper-$(version).tar.gz

clean:
	@rm -f chef-zookeeper-*.tar.gz
	@rm -rf $(builddir)
	@rm -f metadata.json
