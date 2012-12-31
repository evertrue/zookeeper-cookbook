#
# Cookbook Name:: zookeeper
# Recipe:: Exhibitor
#
# Copyright 2012, Simple
#
# All rights reserved - Do Not Redistribute
#


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

local_file = "exhibitor-#{node[:exhibitor][:version]}.tar.gz"

remote_file "#{Chef::Config[:file_cache_path]}/#{local_file}" do
  owner "root"
  source node[:exhibitor][:mirror]
  mode "0644"
  not_if { File.exists? "#{Chef::Config[:file_cache_path]}/#{local_file}" }
end

bash "untar exhibitor" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}"
  code %(tar zxf #{local_file})
  not_if { File.exists? "#{Chef::Config[:file_cache_path]}/exhibitor-#{node[:exhibitor][:version]}" }
end

bash "build exhibitor" do
  user "root"
  cwd "#{Chef::Config[:file_cache_path]}/exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle"
  code %(#{Chef::Config[:file_cache_path]}/exhibitor-#{node[:exhibitor][:version]}/gradlew jar)
  not_if {File.exists? "#{Chef::Config[:file_cache_path]}/exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle/build/" }
end

bash "move exhibitor jar" do
  user node[:zookeeper][:user]
  # TODO: change gradle path hardcode
  code %(cp #{Chef::Config[:file_cache_path]}/exhibitor-#{node[:exhibitor][:version]}/exhibitor-standalone/src/main/resources/buildscripts/standalone/gradle/build/libs/*.jar /opt/exhibitor/#{node[:exhibitor][:version]}.jar)
  not_if {File.exists? "/opt/exhibitor/#{node[:exhibitor][:version]}.jar"}
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
  variables(
      :user => node[:zookeeper][:user],
      :version => node[:exhibitor][:version],
      :opts => node[:exhibitor][:opts]
  )
end

# TODO
# JMX? (servo) -- monitoring
# set up logging?
# Test on prod
