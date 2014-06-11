# recipes/default.rb
#
# Copyright 2013, Simple Finance Technology Corp.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

node.override['build-essential']['compile_time'] = true

include_recipe 'build-essential::default'
include_recipe 'java::default'

zookeeper node[:zookeeper][:version] do
  user        node[:zookeeper][:user]
  mirror      node[:zookeeper][:mirror]
  checksum    node[:zookeeper][:checksum]
  install_dir node[:zookeeper][:install_dir]
  action      :install
end

config_path = ::File.join(node[:zookeeper][:install_dir],
                          "zookeeper-#{node[:zookeeper][:version]}",
                          'conf',
                          'zoo.cfg')

zookeeper_config config_path do
  config node[:zookeeper][:config]
  user   node[:zookeeper][:user]
  action :render
end
