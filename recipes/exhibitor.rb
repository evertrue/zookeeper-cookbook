#
# Cookbook Name:: zookeeper
# Recipe:: Exhibitor
#
# Copyright 2012, Simple
#
# All rights reserved - Do Not Redistribute
#
# remove zk service
# moive default into zookeeper recipe
# have default do base install


include_recipe "zookeeper::zookeeper"

["/opt/exhibitor",
  node[:exhibitor][:snapshot_dir],
  node[:exhibitor][:transaction_dir],
  node[:exhibitor][:log_index_dir]
].each do |dir|
    directory dir do
      owner node[:zookeeper][:user]
      mode "0755"
    end
end

remote_file "#{Chef::Config[:file_cache_path]}/exhibitor-#{node[:exhibitor][:version]}.tar.gz" do
  owner "root"
  source node[:exhibitor][:mirror]
  mode "0644"
  not_if { File.exists? "#{Chef::Config[:file_cache_path]}/exhibitor-#{node[:exhibitor][:version]}.tar.gz" }
end

bash "untar exhibitor" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}"
  code %(tar zxf exhibitor-#{node[:exhibitor][:version]}.tar.gz)
  not_if { File.exists? "#{Chef::Config[:file_cache_path]}/exhibitor-exhibitor-#{node[:exhibitor][:version]}" }
end

bash "build exhibitor" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}/exhibitor-exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle"
  code %(#{Chef::Config[:file_cache_path]}/exhibitor-exhibitor-#{node[:exhibitor][:version]}/gradlew jar)
  not_if {File.exists? "#{Chef::Config[:file_cache_path]}/exhibitor-exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle/build/" }
end

bash "move exhibitor jar" do
  user node[:zookeeper][:user]
  code %(cp #{Chef::Config[:file_cache_path]}/exhibitor-exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle/build/libs/gradle-1.4.2.jar /opt/exhibitor/exhibitor-#{node[:exhibitor][:version]}.jar)
  not_if {File.exists? "/opt/exhibitor/exhibitor-#{node[:exhibitor][:version]}.jar"}
end

service "exhibitor" do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :status => true, :restart => true
  # action [ :start ]
end

template "exhibitor.upstart.conf" do
  path "/etc/init/exhibitor.conf"
  source "exhibitor.upstart.conf.erb"
  owner "root"
  group "root"
  mode "0644"
  notifies :restart, resources(:service => "exhibitor")
end

# TODO
# s3credentials template (use iam role provider)
# JM? (servo) -- monitoring
# set up logging?
# Test on prod
# Rename cookbook to zookeeper
