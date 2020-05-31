#
# Cookbook:: zookeeper
# Resource:: default
#
# Copyright:: 2014, Simple Finance Technology Corp.
# Copyright:: 2016, EverTrue, Inc.
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

property :version,             String, default: '3.6.1'
property :mirror,              String, default: 'http://archive.apache.org/dist/zookeeper/'
property :checksum,            String
property :username,            String, default: 'zookeeper'
property :user_home,           String, default: '/home/zookeeper'
property :install_dir,         String, default: '/opt'
property :log_dir,             String, default: '/var/log/zookeeper'
property :data_dir,            String, default: '/var/lib/zookeeper'
property :use_java_cookbook,   [true, false], default: true
property :java_version,        String, default: '11'

# Install Zookeeper
action :install do
  apt_update 'zookeeper' do
    only_if { platform_family? 'debian' }
  end

  if new_resource.use_java_cookbook
    openjdk_install new_resource.java_version
  else
    Chef::Log.info "Assuming you've provided your own Java"
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
    url         "#{new_resource.mirror}/zookeeper-#{new_resource.version}/apache-zookeeper-#{new_resource.version}-bin.tar.gz"
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
