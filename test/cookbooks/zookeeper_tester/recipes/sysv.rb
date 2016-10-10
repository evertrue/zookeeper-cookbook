
zookeeper node['zookeeper']['version']
zookeeper_config 'zoo.cfg'
zookeeper_service 'zookeeper' do
  service_style 'sysv'
end

include_recipe 'zookeeper_tester::node'
