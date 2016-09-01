#
# Cookbook Name:: zookeeper
# Resource:: service

# Copyright 2016, EverTrue, Inc.
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

actions :enable, :disable, :start, :stop, :restart, :reload

default_action :enable

property :service_provider,  default: :runit
property :install_dir,       default: '/opt/zookeeper'
property :conf_dir,          default: '/opt/zookeeper/conf'
property :username,          default: 'zookeeper'

def service_resource(service_actions)
  # TODO: Figure out how to get zookeeper-env.sh passed in to service

  poise_service 'zookeeper' do
    command   "#{install_dir}/bin/zkServer.sh"
    user      username
    directory install_dir
    provider  service_provider
    action    service_actions
  end
end

action :enable do
  service_resource :enable
end

action :disable do
  service_resource :disable
end

action :start do
  service_resource :start
end

action :stop do
  service_resource :stop
end

action :restart do
  service_resource :restart
end

action :reload do
  service_resource :reload
end
