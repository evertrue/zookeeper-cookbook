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
remote_file ::File.join(Chef::Config[:file_cache_path], dest_file) do
  owner "root"
  mode "0644"
  source node[:gradle][:mirror]
  checksum node[:gradle][:checksum]
  action :create
end

package "unzip" do
  action :install
end

dest_path = ::File.join(Chef::Config[:file_cache_path], "gradle-#{node[:gradle][:version]}")
unless ::File.exists?(dest_path)
  execute "unzip gradle" do
    user "root"
    cwd Chef::Config[:file_cache_path]
    command "unzip #{dest_file}"
  end
end

ENV["PATH"] += ":#{dest_path}/bin"
