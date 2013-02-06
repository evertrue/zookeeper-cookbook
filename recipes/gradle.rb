#
# Cookbook Name:: zookeeper
# Recipe:: gradle
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

bash "unzip gradle" do
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
