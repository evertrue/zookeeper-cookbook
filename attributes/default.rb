default[:zookeeper][:version] = "3.4.5"
default[:zookeeper][:mirror] = "http://mirrors.ibiblio.org/apache/zookeeper/zookeeper-#{default[:zookeeper][:version]}/zookeeper-#{default[:zookeeper][:version]}.tar.gz"
default[:zookeeper][:checksum] = 'e92b634e99db0414c6642f6014506cc22eefbea42cc912b57d7d0527fb7db132'
default[:zookeeper][:install_dir] = "/opt/zookeeper"
default[:zookeeper][:user] = "zookeeper"
default[:zookeeper][:group] = "zookeeper"

default[:gradle][:version] = "1.5"
default[:gradle][:mirror] = "http://services.gradle.org/distributions/gradle-#{default[:gradle][:version]}-bin.zip"
default[:gradle][:checksum] = 'a5511a0659caa47d9d74fd2844c9da43157d2f78e63a0223c6289d88f5aaecbe'

# Exhibitor install options:
#    one of download or build
#
#    build will pull down gradle and build exhibitor on the server
default[:exhibitor][:install_method] = 'build'

#    dowlnload will pull down a prebuilt exhibitor jar
#default[:exhibitor][:mirror] = 'http://example.com/exhibitor-1.5.0.jar'
#default[:exhibitor][:install_method] = 'download'
#default[:exhibitor][:checksum] = ''


default[:exhibitor][:version] = "1.5.0"
default[:exhibitor][:install_dir] = "/opt/exhibitor"


default[:exhibitor][:script_dir] = '/usr/local/bin/'

default[:exhibitor][:snapshot_dir] = "/tmp/zookeeper"
default[:exhibitor][:transaction_dir] = "/tmp/zookeeper"
default[:exhibitor][:log_index_dir] = "/tmp/zookeeper_log_indexes"
default[:exhibitor][:log_to_syslog] = "1"

# Port for the HTTP Server
default[:exhibitor][:opts][:port] = "8080"
default[:exhibitor][:opts][:hostname] =  node[:ipaddress]
default[:exhibitor][:opts][:defaultconfig] = "#{node[:exhibitor][:install_dir]}/exhibitor.properties"

default[:exhibitor][:opts][:configtype] = "file"

default[:exhibitor][:loglevel] = "info"

# For --configtype s3, set:
# [:exhibitor][:s3key] = "key"
# [:exhibitor][:s3secret] = "secret"
# [:exhibitor][:opts][:s3config] = "bucket:config-key"
# [:exhibitor][:opts][:s3region] = "region" # i.e. us-east-1

# For --contiftype file
default[:exhibitor][:opts][:fsconfigdir] = "/tmp"

default[:exhibitor][:defaultconfig][:cleanup_period_ms] = 5 * 60 * 1000
default[:exhibitor][:defaultconfig][:zookeeper_install_directory] = "#{node[:zookeeper][:install_dir]}/*"
default[:exhibitor][:defaultconfig][:check_ms] = '30000'
default[:exhibitor][:defaultconfig][:backup_period_ms] = '0'
default[:exhibitor][:defaultconfig][:client_port] = '2181'
default[:exhibitor][:defaultconfig][:cleanup_max_files] = '20'
default[:exhibitor][:defaultconfig][:backup_max_store_ms] = '0'
default[:exhibitor][:defaultconfig][:connect_port] = '2888'
default[:exhibitor][:defaultconfig][:backup_extra] = ''
default[:exhibitor][:defaultconfig][:observer_threshold] = '0'
default[:exhibitor][:defaultconfig][:election_port] = '3888'
default[:exhibitor][:defaultconfig][:zoo_cfg_extra] = 'tickTime\=2000&initLimit\=10&syncLimit\=5'
default[:exhibitor][:defaultconfig][:auto_manage_instances_settling_period_ms] = '0'
default[:exhibitor][:defaultconfig][:auto_manage_instances] = '1'
default[:exhibitor][:defaultconfig][:servers_spec] = "1:#{node[:ipaddress]}"


# default options. see https://github.com/Netflix/exhibitor/wiki/Running-Exhibitor
#
# If true, enables AWS S3 backup of ZooKeeper log files (s3credentials may be provided as well).
# default[:exhibitor][:opts][:s3backup] = "false"
# Max lines of logging to keep in memory for display.
# default[:exhibitor][:opts][:loglines] = "1000"
# If true, the Explorer UI will allow nodes to be modified (use with caution).
# default[:exhibitor][:opts][:nodemodification] = "false"
# true/false (default is false).
# If enabled, ZooKeeper will be queried once a minute for its state via the 'mntr' four letter word
# (this requires ZooKeeper 3.4.x+). Servo will be used to publish this data via JMX.
# default[:exhibitor][:opts][:servo] = "false"
# Connection timeout (ms) for ZK connections.
#default[:exhibitor][:opts][:timeout] = "30000"
# Period (ms) to check for shared config updates.
#default[:exhibitor][:opts][:configcheckms] = 30000
# Styling used for the JQuery-based UI. Currently available options: red, black, custom
#default[:exhibitor][:opts][:jquerystyle] = "red"
# Extra text to display in UI header
#default[:exhibitor][:opts][:headingtext] = "Exhibitor"

