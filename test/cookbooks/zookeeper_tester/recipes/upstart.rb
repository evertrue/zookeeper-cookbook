
zookeeper '3.4.8'
zookeeper_config 'zoo.cfg'
zookeeper_service 'zookeeper' do
  service_style 'upstart'
  action :enable
end

include_recipe 'zookeeper_tester::node'

execute 'hello' do
  command "echo 'hello world'"
  notifies :restart, 'zookeeper_service[zookeeper]', :immediately
end
