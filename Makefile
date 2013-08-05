metadata.json:
	 knife cookbook metadata from file metadata.rb

chef-zookeeper.tgz:
	git archive --format tgz -o chef-zookeeper.tgz --prefix zookeeper/ master
