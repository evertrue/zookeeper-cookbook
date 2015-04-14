# coding: UTF-8

require 'serverspec'

# Required by serverspec
set :backend, :exec

# Something we need in order to get 'describe server' to work
set :path, '/sbin:/usr/local/sbin:$PATH'

# Used by testing
require 'zookeeper'