# attributes/default.rb

default[:zookeeper][:version]     = '3.4.5'
default[:zookeeper][:checksum]    = 'e92b634e99db0414c6642f6014506cc22eefbea42cc912b57d7d0527fb7db132'
default[:zookeeper][:install_dir] = '/opt/zookeeper'
default[:zookeeper][:user]        = 'zookeeper'
default[:zookeeper][:group]       = 'zookeeper'

# Necessary for the ZK gem
override['build-essential']['compile_time'] = true
