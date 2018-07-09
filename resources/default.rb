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

property :version,             String, name_property: true
property :mirror,              String, default: 'http://apache.mirrors.tds.net/zookeeper/'
property :checksum,            String
property :username,            String, default: 'zookeeper'
property :user_home,           String, default: '/home/zookeeper'
property :install_dir,         String, default: '/opt'
property :log_dir,             String, default: '/var/log/zookeeper'
property :data_dir,            String, default: '/var/lib/zookeeper'
property :use_java_cookbook,   [true, false], default: true

# Install Zookeeper
action :install do
  apt_update 'zookeeper' do
    action :nothing
  end.run_action :periodic if node['platform_family'] == 'debian'

  if new_resource.use_java_cookbook
    include_recipe 'java::default'
  else
    Chef::Log.info "Assuming you've provided your own Java"
  end

  # build-essential is required to build the zookeeper gem
  build_essential 'install compilation tools' do
    compile_time true
  end

  chef_gem 'zookeeper' do
    compile_time false
  end

  group new_resource.username

  user new_resource.username do
    group       new_resource.username
    home        new_resource.user_home
    manage_home true
    system      true
  end

  directory new_resource.install_dir do
    recursive true
  end

  ark 'zookeeper' do
    url         "#{new_resource.mirror}/zookeeper-#{new_resource.version}/zookeeper-#{new_resource.version}.tar.gz"
    version     new_resource.version
    prefix_root new_resource.install_dir
    prefix_home new_resource.install_dir
    checksum    new_resource.checksum if new_resource.checksum
    owner       new_resource.username
    group       new_resource.username
  end

  directory new_resource.log_dir do
    owner     new_resource.username
    group     new_resource.username
    mode      '0755'
    recursive true
  end

  directory new_resource.data_dir do
    owner     new_resource.username
    group     new_resource.username
    mode      '0700'
    recursive true
  end
end

action :uninstall do
  Chef::Log.error "Unimplemented method :uninstall for resource `zookeeper'"
end
