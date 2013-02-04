#
# Cookbook Name:: zookeeper
# Recipe:: zookeeper
#
# Copyright 2013, Simple Finance Technology Corp.
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

zk_basename = "zookeeper-#{node[:zookeeper][:version]}"

remote_file "#{Chef::Config[:file_cache_path]}/#{zk_basename}.tar.gz" do
  owner "root"
  source node[:zookeeper][:mirror]
  mode "0644"
end

directory node[:zookeeper][:install_dir] do
  owner node[:exhibitor][:user]
  mode "0755"
end

execute "untar zookeeper" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}"
  code %(tar zxf #{zk_basename}.tar.gz)
  creates "#{Chef::Config[:file_cache_path]}/#{zk_basename}"
end

execute "copy zk root" do
  user node[:exhibitor][:user]
  cwd "#{Chef::Config[:file_cache_path]}"
  code %(cp -r #{zk_basename} #{node[:zookeeper][:install_dir]}/)
  creates "#{node[:zookeeper][:install_dir]}/#{zk_basename}"
end
