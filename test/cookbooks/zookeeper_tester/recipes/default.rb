
zookeeper node['zookeeper']['version']
zookeeper_config 'zoo.cfg'
zookeeper_service 'zookeeper'

include_recipe 'zookeeper_tester::node'
