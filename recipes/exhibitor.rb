#
# Cookbook Name:: zookeeper
# Recipe:: Exhibitor
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
#

include_recipe "zookeeper::gradle"

user node[:exhibitor][:user] do
  uid node[:exhibitor][:uid]
  gid node[:exhibitor][:group]
end

include_recipe "zookeeper::zookeeper"

[node[:exhibitor][:install_dir],
  node[:exhibitor][:snapshot_dir],
  node[:exhibitor][:transaction_dir],
  node[:exhibitor][:log_index_dir]
].each do |dir|
    directory dir do
      owner node[:exhibitor][:user]
      mode "0755"
    end
end

jar_file = "#{Chef::Config[:file_cache_path]}/exhibitor/build/libs/exhibitor-#{node[:exhibitor][:version]}.jar"

bash "build exhibitor" do
  cwd "#{Chef::Config[:file_cache_path]}/exhibitor"
  code %(gradle jar)
  creates jar_file
end

bash "move exhibitor jar" do
  code %(cp #{jar_file} #{node[:exhibitor][:install_dir]}/#{node[:exhibitor][:version]}.jar)
  creates "#{node[:exhibitor][:install_dir]}/#{node[:exhibitor][:version]}.jar"
end

file "#{node[:exhibitor][:install_dir]}/#{node[:exhibitor][:version]}.jar" do
  owner node[:exhibitor][:user]
end

template "exhibitor.upstart.conf" do
  path "/etc/init/exhibitor.conf"
  source "exhibitor.upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :stop, "service[exhibitor]" # :restart doesn't reload upstart conf
  notifies :start, "service[exhibitor]"
  variables(
      :user => node[:exhibitor][:user],
      :jar => "#{node[:exhibitor][:install_dir]}/#{node[:exhibitor][:version]}.jar",
      :opts => node[:exhibitor][:opts]
  )
end

template "defaultconfig.erb" do
  path node[:exhibitor][:opts][:defaultconfig]
  source "defaultconfig.erb"
  owner node[:exhibitor][:user]
  mode "0644"
  variables(
      :snapshot_dir => node[:exhibitor][:snapshot_dir],
      :transaction_dir => node[:exhibitor][:transaction_dir],
      :log_index_dir => node[:exhibitor][:log_index_dir],
      :defaultconfig => node[:exhibitor][:defaultconfig]
  )
end

service "exhibitor" do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :status => true, :restart => true
  action :start
end

# TODO
# JMX? (servo) -- monitoring
# set up logging?
