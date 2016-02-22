# attributes/default.rb

default[:apt][:compile_time_update] = true

default[:zookeeper][:version]     = '3.4.6'
default[:zookeeper][:checksum]    =
  '01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994'
default[:zookeeper][:mirror]      = 'http://www.poolsaboveground.com/apache/zookeeper'
default[:zookeeper][:user]        = 'zookeeper'
default[:zookeeper][:user_home]   = '/home/zookeeper'
default[:zookeeper][:install_dir] = '/opt/zookeeper'
default[:zookeeper][:use_java_cookbook] = true
default[:zookeeper][:config_dir]  = "#{node[:zookeeper][:install_dir]}/" \
                                    'zookeeper-%{zookeeper_version}/conf'
default[:zookeeper][:conf_file]   = 'zoo.cfg'
default[:zookeeper][:java_opts]   = '-Xms128M -Xmx512M'
default[:zookeeper][:log_dir]     = '/var/log/zookeeper'

# One of: 'upstart', 'runit', 'exhibitor', 'sysv'
default[:zookeeper][:service_style] = 'runit'

default[:zookeeper][:config] = {
  clientPort: 2181,
  dataDir: '/var/lib/zookeeper',
  tickTime: 2000
}

# Set a default value to avoid Ruby errors
default[:zookeeper][:env_vars] = false

# Examples of optional environment vars
# See the zookeeper config files (conf/zkEnv.sh, etc.) for more examples
# set[:zookeeper][:env_vars] = {
#   ZOO_LOG4J_PROP: 'INFO,ROLLINGFILE',
#   ZOO_LOG_DIR: '/var/log/zookeeper'
# }
