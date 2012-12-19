default[:zookeeper][:version] = "3.4.5"
default[:zookeeper][:mirror] = "http://mirrors.ibiblio.org/apache/zookeeper/zookeeper-#{default[:zookeeper][:version]}/zookeeper-#{default[:zookeeper][:version]}.tar.gz"
default[:zookeeper][:user] = "exhibitor"

default[:exhibitor][:version] = "1.4.3"
default[:exhibitor][:mirror] = "https://github.com/Netflix/exhibitor/archive/exhibitor-#{default[:exhibitor][:version]}.tar.gz"

# default[:exhibitor][:snapshot_dir] = "/mnt/zookeeper_snapshots"
# default[:exhibitor][:transaction_dir] = "/mnt/zookeeper_transactions"
# default[:exhibitor][:log_index_dir] = "/mnt/zookeeper_log_indexes"
default[:exhibitor][:snapshot_dir] = "/tmp/zookeeper_snapshots"
default[:exhibitor][:transaction_dir] = "/tmp/zookeeper_transactions"
default[:exhibitor][:log_index_dir] = "/tmp/zookeeper_log_indexes"

default[:exhibitor][:s3config] = "exhibitor:exhibitor-config"
default[:exhibitor][:s3backup] = "true"
