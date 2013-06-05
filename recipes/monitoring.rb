#
# Cookbook Name:: zookeeper
# Recipe:: monitoring
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

sensu_check 'zookeeper-metrics' do
  command 'zookeeper-metrics.rb'
  subscribers node[:zookeeper][:sensu][:subscribers]
  interval node[:zookeeper][:sensu][:interval]
  handlers node[:zookeeper][:sensu][:handlers]
  additional(node[:zookeeper][:sensu][:additional])
end

