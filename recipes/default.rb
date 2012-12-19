#
# Cookbook Name:: zookeeper
# Recipe:: default
#
# Copyright 2012, Simple
#
# All rights reserved - Do Not Redistribute
#

include_recipe "java"

remote_file "/tmp/zookeeper-#{node[:zookeeper][:version]}.tar.gz" do
  source "http://mirrors.ibiblio.org/apache/zookeeper/zookeeper-#{node[:zookeeper][:version]}/zookeeper-#{node[:zookeeper][:version]}.tar.gz"
  mode "0644"
end

directory "/opt/zookeeper" do
  owner "root"
  group "root"
  mode 0755
end

bash "untar zookeeper" do
  user "root"
  cwd "/tmp"
  code %(tar zxf /tmp/zookeeper-#{node[:zookeeper][:version]}.tar.gz)
  not_if { File.exists? "/tmp/zookeeper-#{node[:zookeeper][:version]}" }
end

bash "copy zk root" do
  user "root"
  cwd "/tmp"
  code %(cp -r /tmp/zookeeper-#{node[:zookeeper][:version]} /opt/zookeeper/)
  not_if { File.exists? "/opt/zookeeper/zookeeper-#{node[:zookeeper][:version]}/lib" }
end

service "zookeeper" do
end
