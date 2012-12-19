set_unless[:zookeeper][:version] = "3.4.5"

set_unless[:exhibitor][:version] = "1.4.3"

set_unless[:exhibitor][:snapshot_dir] = "/mnt/zookeeper_snapshots"
set_unless[:exhibitor][:transaction_dir] = "/mnt/zookeeper_transactions"
set_unless[:exhibitor][:log_index_dir] = "/mnt/zookeeper_log_indexes"
# set_unless[:exhibitor][:snapshot_dir] = "/tmp/zookeeper_snapshots"
# set_unless[:exhibitor][:transaction_dir] = "/tmp/zookeeper_transactions"
# set_unless[:exhibitor][:log_index_dir] = "/tmp/zookeeper_log_indexes"

set_unless[:exhibitor][:s3config] = "exhibitor:exhibitor-config"
set_unless[:exhibitor][:s3backup] = "true"
