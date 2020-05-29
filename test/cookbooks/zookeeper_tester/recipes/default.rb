zookeeper 'zookeeper'

zookeeper_config 'zoo.cfg' do
  conf_dir '/etc/zookeeper/conf'
  env_vars({
    'ZOO_LOG4J_PROP' => 'INFO,ROLLINGFILE',
  })
end

zookeeper_service 'zookeeper' do
  conf_dir '/etc/zookeeper/conf'
end
