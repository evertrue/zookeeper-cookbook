# attributes/default.rb

allocated_memory = "#{(node['memory']['total'].to_i * 0.8).floor / 1024}m"

default['zookeeper']['version']     = '3.5.6'
default['zookeeper']['checksum']    = nil
default['zookeeper']['mirror']      = 'http://apache.mirrors.tds.net/zookeeper'
default['zookeeper']['user']        = 'zookeeper'
default['zookeeper']['user_home']   = '/home/zookeeper'
default['zookeeper']['install_dir'] = '/opt'
default['zookeeper']['use_java_cookbook'] = true
default['zookeeper']['conf_dir']    = "#{node['zookeeper']['install_dir']}/zookeeper/conf"
default['zookeeper']['conf_file']   = 'zoo.cfg'
default['zookeeper']['java_opts']   =
  "-Xmx#{allocated_memory} " \
  '-Dzookeeper.serverCnxnFactory=org.apache.zookeeper.server.NettyServerCnxnFactory'
default['zookeeper']['log_dir']     = '/var/log/zookeeper'

# One of: 'upstart', 'runit', 'exhibitor', systemd'
default['zookeeper']['service_style'] = 'runit'

default['zookeeper']['config'] = {
  'clientPort' => 2181,
  'secureClientPort' => 2182,
  'dataDir' => '/var/lib/zookeeper',
  'tickTime' => 2000,
  'initLimit' => 5,
  'syncLimit' => 2,
}

default['zookeeper']['env_vars'] = {}

# Examples of an additional environment var
# See the zookeeper config files (conf/zkEnv.sh, etc.) for more options
# set['zookeeper']['env_vars']['ZOO_LOG4J_PROP'] = 'INFO,ROLLINGFILE'

default['java']['jdk_version'] = '8'
