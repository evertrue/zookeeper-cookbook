#
# Cookbook Name:: zookeeper
# Recipe:: monitoring
#
# Copyright 2012 Simple Finance Technology Corp. All rights reserved.
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

include_recipe "nagios"

cookbook_file "#{node[:exhibitor][:nagios][:plugins_dir]}/check_exhibitor.py" do
    mode "0755"
    user node[:exhibitor][:nagios][:user]
    group node[:exhibitor][:nagios][:group]
    backup false
end

nagios_conf "check_exhibitor" do
  variables({
      :host => node[:exhibitor][:hostname],
      :notes_url => node[:exhibitor][:nagios][:notes_url]
  })
end
