#
# Cookbook Name:: zookeeper
# Recipe:: Exhibitor
#
# Copyright 2013, Simple Finance Technology Corp.
#
# All rights reserved - Do Not Redistribute

dest_file = "gradle-#{node[:gradle][:version]}.zip"

remote_file "#{Chef::Config[:file_cache_path]}/#{dest_file}" do
  owner "root"
  source node[:gradle][:mirror]
  mode "0644"
  action :create_if_missing
end

package "unzip" do
  action :install
end

dest_path = "#{Chef::Config[:file_cache_path]}/gradle-#{node[:gradle][:version]}"

script "unzip gradle" do
  user "root"
  cwd Chef::Config[:file_cache_path]
  code %(unzip #{dest_file})
  creates dest_path
end

ENV["PATH"] += ":#{dest_path}/bin"

directory "#{Chef::Config[:file_cache_path]}/exhibitor"

template "build.gradle" do
  path "#{Chef::Config[:file_cache_path]}/exhibitor/build.gradle"
  source "build.gradle.erb"
  variables(
    :version => node[:exhibitor][:version]
  )
end
