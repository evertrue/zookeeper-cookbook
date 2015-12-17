# attributes/default.rb

default[:apt][:compile_time_update] = true

default[:zookeeper][:version]     = '3.4.7'
default[:zookeeper][:checksum]    = '2e043e04c4da82fbdb38a68e585f3317535b3842c726e0993312948afcc83870'
default[:zookeeper][:mirror]      = 'http://www.poolsaboveground.com/apache/zookeeper'
default[:zookeeper][:user]        = 'zookeeper'
default[:zookeeper][:install_dir] = '/opt/zookeeper'
default[:zookeeper][:use_java_cookbook] = true
default[:zookeeper][:config_dir]  = "#{node[:zookeeper][:install_dir]}/" \
                                    'zookeeper-%{zookeeper_version}/conf'
default[:zookeeper][:conf_file]   = 'zoo.cfg'
default[:zookeeper][:java_opts] = "-Xms128M -Xmx512M"
default[:zookeeper][:log_dir]     = "/var/log/zookeeper"

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
