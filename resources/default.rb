#
# Cookbook Name:: zookeeper
# Resource:: default
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

default_action :install

property :version,             name_attribute: true
property :mirror,              default: 'http://apache.mirrors.tds.net/zookeeper/'
property :checksum,            String
property :username,            default: 'zookeeper'
property :user_home,           default: '/home/zookeeper'
property :install_dir,         default: '/opt'
property :log_dir,             default: '/var/log/zookeeper'
property :data_dir,            default: '/var/lib/zookeeper'
property :use_java_cookbook,   default: true

# Install Zookeeper
action :install do
  if Chef::VersionConstraint.new('< 12.10.0').include? Chef::VERSION
    raise 'This recipe requires Chef version 12.10 or greater'
  end

  apt_update 'zookeeper' do
    action :nothing
  end.run_action :periodic if node['platform_family'] == 'debian'

  if use_java_cookbook
    include_recipe 'java::default'
  else
    Chef::Log.info "Assuming you've provided your own Java"
  end

  # build-essential is required to build the zookeeper gem
  node.override['build-essential']['compile_time'] = true
  include_recipe 'build-essential::default'

  chef_gem 'zookeeper' do
    compile_time false
  end

  group username

  user username do
    group       username
    home        user_home
    manage_home true
    system      true
  end

  directory install_dir do
    recursive true
  end
 
  ark 'zookeeper' do
    url         "#{mirror}/zookeeper-#{new_resource.version}/zookeeper-#{new_resource.version}.tar.gz"
    version     new_resource.version
    prefix_root install_dir
    prefix_home install_dir
    checksum    new_resource.checksum if property_is_set? :checksum
  end

  directory log_dir do
    owner     username
    group     username
    mode      '0755'
    recursive true
  end

  directory data_dir do
    owner     username
    group     username
    mode      '0700'
    recursive true
  end
end

action :uninstall do
  Chef::Log.error "Unimplemented method :uninstall for resource `zookeeper'"
end
