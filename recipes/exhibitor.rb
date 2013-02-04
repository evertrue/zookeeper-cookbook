#
# Cookbook Name:: zookeeper
# Recipe:: Exhibitor
#
# Copyright 2013, Simple Finance Technology Corp.
#
# All rights reserved - Do Not Redistribute
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
  user node[:exhibitor][:user]
  code %(cp #{jar_file} #{node[:exhibitor][:install_dir]}/#{node[:exhibitor][:version]}.jar)
  creates "#{node[:exhibitor][:install_dir]}/#{node[:exhibitor][:version]}.jar"
end

service "exhibitor" do
  provider Chef::Provider::Service::Upstart
  supports :start => true, :status => true, :restart => true
  action [ :start ]
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

# TODO
# JMX? (servo) -- monitoring
# set up logging?
