# attributes/default.rb

allocated_memory = "#{(node['memory']['total'].to_i * 0.8).floor / 1024}m"

default['zookeeper']['version']     = '3.4.12'
default['zookeeper']['checksum']    =
  'c686f9319050565b58e642149cb9e4c9cc8c7207aacc2cb70c5c0672849594b9'
default['zookeeper']['mirror']      = 'http://apache.mirrors.tds.net/zookeeper/'
default['zookeeper']['user']        = 'zookeeper'
default['zookeeper']['user_home']   = '/home/zookeeper'
default['zookeeper']['install_dir'] = '/opt'
default['zookeeper']['use_java_cookbook'] = true
default['zookeeper']['conf_dir']    = "#{node['zookeeper']['install_dir']}/zookeeper/conf"
default['zookeeper']['conf_file']   = 'zoo.cfg'
default['zookeeper']['java_opts']   = "-Xmx#{allocated_memory}"
default['zookeeper']['log_dir']     = '/var/log/zookeeper'

# One of: 'upstart', 'runit', 'exhibitor', systemd'
default['zookeeper']['service_style'] = 'runit'

default['zookeeper']['config'] = {
  'clientPort' => 2181,
  'dataDir'    => '/var/lib/zookeeper',
  'tickTime'   => 2000,
  'initLimit'  => 5,
  'syncLimit'  => 2,
}

default['zookeeper']['env_vars'] = {}

# Examples of an additional environment var
# See the zookeeper config files (conf/zkEnv.sh, etc.) for more options
# set['zookeeper']['env_vars']['ZOO_LOG4J_PROP'] = 'INFO,ROLLINGFILE'
