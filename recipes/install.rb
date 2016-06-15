# recipes/install.rb
#
# Copyright 2014, Simple Finance Technology Corp.
# Copyright 2016, EverTrue, Inc.
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

if Chef::VersionConstraint.new('< 12.10.0').include? Chef::VERSION
  raise 'This recipe requires Chef version 12.10 or greater'
end

apt_update 'zookeeper' do
  action :nothing
end.run_action :periodic

if node['zookeeper']['use_java_cookbook'] == true
  include_recipe 'java::default'
else
  Chef::Log.info("Assuming you've provided your own Java")
end

zookeeper node['zookeeper']['version'] do
  username    node['zookeeper']['user']
  user_home   node['zookeeper']['user_home']
  mirror      node['zookeeper']['mirror']
  checksum    node['zookeeper']['checksum']
  install_dir node['zookeeper']['install_dir']
  log_dir     node['zookeeper']['log_dir']
  data_dir    node['zookeeper']['config']['dataDir']
end
