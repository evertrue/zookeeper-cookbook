#
# Cookbook Name:: zookeeper
# Recipe:: zookeeper
#
# Copyright 2012, Simple
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

remote_file "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz" do
  owner "root"
  source node[:zookeeper][:mirror]
  mode "0644"
  not_if { File.exists? "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz" }
end

directory "/opt/zookeeper" do
  owner node[:exhibitor][:user]
  mode "0755"
end

bash "untar zookeeper" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}"
  code %(tar zxf #{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz)
  not_if { File.exists? "#{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]}" }
end

bash "copy zk root" do
  user node[:exhibitor][:user]
  cwd "#{Chef::Config[:file_cache_path]}"
  code %(cp -r #{Chef::Config[:file_cache_path]}/zookeeper-#{node[:zookeeper][:version]} /opt/zookeeper/)
  not_if { File.exists? "/opt/zookeeper/zookeeper-#{node[:zookeeper][:version]}/lib" }
end
