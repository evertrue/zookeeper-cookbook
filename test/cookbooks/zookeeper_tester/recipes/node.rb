zookeeper_node '/testing' do
  connect_str 'localhost:2181'
  data 'some data'
end

zookeeper_node '/secure' do
  connect_str  'localhost:2181'
  data         'sensitive data'
  auth_scheme  'digest'
  auth_cert    'user1:pwd1'
  acl_digest   'user1:a9l5yfb9zl8WCXjVmi5/XOC0Ep4=' => Zk::PERM_ALL
  acl_ip       '127.0.0.1' => Zk::PERM_READ | Zk::PERM_WRITE
  acl_world    Zk::PERM_NONE
end
