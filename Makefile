metadata.json:
	ln -s $$PWD zookeeper && knife cookbook metadata zookeeper -o $$PWD && rm -f zookeeper
