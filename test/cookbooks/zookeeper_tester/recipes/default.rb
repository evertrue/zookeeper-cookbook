
zookeeper node['zookeeper']['version'] do
  checksum node['zookeeper']['checksum']
end

zookeeper_config 'zoo.cfg'
zookeeper_service 'zookeeper'

include_recipe 'zookeeper_tester::node'
