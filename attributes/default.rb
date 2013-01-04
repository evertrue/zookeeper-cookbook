default[:zookeeper][:version] = "3.4.5"
default[:zookeeper][:mirror] = "http://mirrors.ibiblio.org/apache/zookeeper/zookeeper-#{default[:zookeeper][:version]}/zookeeper-#{default[:zookeeper][:version]}.tar.gz"

default[:gradle][:version] = "1.3"
default[:gradle][:mirror] = "http://services.gradle.org/distributions/gradle-#{default[:gradle][:version]}-bin.zip"

default[:exhibitor][:version] = "1.4.4"
default[:exhibitor][:user] = "zookeeper"

default[:exhibitor][:snapshot_dir] = "/mnt/zookeeper_snapshots"
default[:exhibitor][:transaction_dir] = "/mnt/zookeeper_transactions"
default[:exhibitor][:log_index_dir] = "/mnt/zookeeper_log_indexes"

default[:exhibitor][:environment] = "stage"

# If true, enables AWS S3 backup of ZooKeeper log files (s3credentials may be provided as well).
default[:exhibitor][:opts][:s3backup] = "true"
# Period (ms) to check for shared config updates.
default[:exhibitor][:opts][:configcheckms] = 30000
# Extra text to display in UI header
default[:exhibitor][:opts][:headingtext] = "Simple"
# Styling used for the JQuery-based UI. Currently available options: red, black, custom
default[:exhibitor][:opts][:jquerystyle] = "black"
# Max lines of logging to keep in memory for display.
default[:exhibitor][:opts][:loglines] = "1000"
# If true, the Explorer UI will allow nodes to be modified (use with caution).
default[:exhibitor][:opts][:nodemodification] = "false"
# Port for the HTTP Server
default[:exhibitor][:opts][:port] = "8080"
# true/false (default is false).
# If enabled, ZooKeeper will be queried once a minute for its state via the 'mntr' four letter word
# (this requires ZooKeeper 3.4.x+). Servo will be used to publish this data via JMX.
default[:exhibitor][:opts][:servo] = "true"
# Connection timeout (ms) for ZK connections.
default[:exhibitor][:opts][:timeout] = "30000"

default[:exhibitor][:opts][:defaultconfig] = "#{Chef::Config[:file_cache_path]}/exhibitor-defaultconfig"
default[:exhibitor][:opts][:s3config] = "com.simple.#{default[:exhibitor][:environment]}.exhibitor:#{default[:exhibitor][:environment]}-config"

default[:exhibitor][:defaultconfig][:cleanup_period_ms] = '30000'
default[:exhibitor][:defaultconfig][:zookeeper_install_directory] = '/opt/zookeeper/*'
default[:exhibitor][:defaultconfig][:check_ms] = '30000'
default[:exhibitor][:defaultconfig][:backup_period_ms] = '0'
default[:exhibitor][:defaultconfig][:client_port] = '2181'
default[:exhibitor][:defaultconfig][:cleanup_max_files] = '3'
default[:exhibitor][:defaultconfig][:backup_max_store_ms] = '0'
default[:exhibitor][:defaultconfig][:connect_port] = '2888'
default[:exhibitor][:defaultconfig][:backup_extra] = ''
default[:exhibitor][:defaultconfig][:observer_threshold] = '0'
default[:exhibitor][:defaultconfig][:election_port] = '3888'
default[:exhibitor][:defaultconfig][:zoo_cfg_extra] = 'tickTime\=2000&initLimit\=10&syncLimit\=5'
default[:exhibitor][:defaultconfig][:auto_manage_instances_settling_period_ms] = '0'
default[:exhibitor][:defaultconfig][:auto_manage_instances] = '1'
