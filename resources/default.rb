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
property :install_dir,         default: '/opt/zookeeper'
property :log_dir,             default: '/var/log/zookeeper'
property :data_dir,            default: '/var/lib/zookeeper'

# Install Zookeeper
action :install do
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

  remote_file "#{file_cache_path}/zookeeper-#{version}.tar.gz" do
    owner    'root'
    group    'root'
    mode     '0644'
    source   "#{mirror}/zookeeper-#{version}/zookeeper-#{version}.tar.gz"
    checksum new_resource.checksum if property_is_set? :checksum
  end

  [
    install_dir,
    log_dir
  ].each do |d|
    directory d do
      owner     username
      group     username
      mode      '0755'
      recursive true
    end
  end

  directory data_dir do
    owner     username
    group     username
    mode      '0700'
    recursive true
  end

  unless ::File.exist? ::File.join(install_dir, "zookeeper-#{version}", "zookeeper-#{version}.jar")
    Chef::Log.info "Zookeeper version #{version} not installed. Installing now!"

    execute 'install zookeeper' do
      cwd     file_cache_path
      command <<-eos
tar -C #{install_dir} -zxf zookeeper-#{version}.tar.gz
chown -R #{user}:#{user} #{install_dir}
      eos
    end
  end
end

action :uninstall do
  Chef::Log.error "Unimplemented method :uninstall for resource `zookeeper'"
end
