
zookeeper '3.4.8'
zookeeper_config 'zoo.cfg'
zookeeper_service 'zookeeper' do
  service_style 'upstart'
end

include_recipe 'zookeeper_tester::node'
