
zookeeper '3.4.8'
zookeeper_config 'zoo.cfg'
zookeeper_service 'zookeeper' do
  service_style 'systemd'
  action :enable
end

include_recipe 'zookeeper_tester::node'
