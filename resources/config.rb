#
# Cookbook Name:: zookeeper
# Resource:: config
#
# Copyright 2014, Simple Finance Technology Corp.
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

default_action :render

property :conf_file,         name_attribute: true
property :conf_dir,          default: '/opt/zookeeper/conf'
property :config,            default: { 'clientPort' => 2181,
                                        'dataDir'    => '/var/lib/zookeeper',
                                        'tickTime'   => 2000,
                                        'initLimit'  => 5,
                                        'syncLimit'  => 2 }
property :log_dir,           default: '/var/log/zookeeper'
property :env_vars,          default: {}
property :user,              default: 'zookeeper'
property :java_opts

action :render do
  directory new_resource.conf_dir do
    owner     new_resource.user
    group     new_resource.user
    recursive true
  end

  file "#{new_resource.conf_dir}/#{new_resource.conf_file}" do
    owner   new_resource.user
    group   new_resource.user
    content properties_config(new_resource.config)
  end

  # Ensure that, even if an attribute is passed in, we can
  # operate on it without running into read-only issues
  env_vars_hash = new_resource.env_vars.to_hash.dup
  env_vars_hash['ZOOCFGDIR']   = new_resource.conf_dir
  env_vars_hash['ZOOCFG']      = new_resource.conf_file
  env_vars_hash['ZOO_LOG_DIR'] = new_resource.log_dir
  env_vars_hash['JVMFLAGS']    = new_resource.java_opts if new_resource.java_opts

  file "#{new_resource.conf_dir}/zookeeper-env.sh" do
    owner   new_resource.user
    group   new_resource.user
    content exports_config(env_vars_hash) + "\n"
  end
end

action :delete do
  Chef::Log.info "Deleting Zookeeper config at #{path}"

  [
    new_resource.conf_file,
    'zookeeper-env.sh',
  ].each do |f|
    file "#{new_resource.conf_dir}/#{f}" do
      action :delete
    end
  end
end
