#
# Cookbook:: zookeeper
# Resource:: service

# Copyright:: 2016, EverTrue, Inc.
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

property :service_style,
         String,
         default: 'systemd',
         callbacks: {
           'Must be a valid service style' =>
             -> (service_style) { %w(systemd exhibitor).include? service_style },
         }
property :install_dir,         String, default: '/opt/zookeeper'
property :conf_dir,            String, default: '/opt/zookeeper/conf'
property :username,            String, default: 'zookeeper'
property :service_actions,     Array, default: %i(enable start)
property :template_cookbook,   String, default: 'zookeeper'
property :restart_on_reconfig, [true, false], default: false

action :create do
  executable_path = "#{new_resource.install_dir}/bin/zkServer.sh"
  env_path = "#{new_resource.conf_dir}/zookeeper-env.sh"

  case new_resource.service_style
  when 'systemd'
    systemd_unit 'zookeeper.service' do
      content({
        Unit: {
          Description: 'ZooKeeper coordination service',
          After: 'network.target',
        },
        Service: {
          User: new_resource.username,
          Group: new_resource.username,
          SyslogIdentifier: 'zookeeper',
          Restart: 'on-failure',
          ExecStart: "/bin/bash -a -c 'source #{env_path} && #{executable_path} start-foreground'",
          LimitNOFILE: 8192,
        },
        Install: {
          WantedBy: 'multi-user.target',
        },
      })
      action %i(create) + new_resource.service_actions
    end
  when 'exhibitor'
    Chef::Log.info 'Assuming Exhibitor will start up Zookeeper.'
  end
end
