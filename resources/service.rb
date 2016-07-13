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

actions :create, :delete

default_action :create

property :service_style,
         default: 'runit',
         callbacks: {
           'Must be a valid service style' =>
             -> (service_style) { %w(runit upstart sysv systemd exhibitor).include? service_style }
         }
property :install_dir,       default: '/opt/zookeeper'
property :username,          default: 'zookeeper'
property :service_actions,   default: [:enable, :start]
property :template_cookbook, default: 'zookeeper'

action :create do
  executable_path = "#{install_dir}/bin/zkServer.sh"

  case service_style
  when 'runit'
    # runit_service does not install runit itself
    include_recipe 'runit'

    runit_service 'zookeeper' do
      default_logger true
      owner          username
      group          username
      options(
        exec:     executable_path,
        username: username
      )
      cookbook       template_cookbook
      action         service_actions
    end
  when 'upstart'
    template '/etc/init/zookeeper.conf' do
      source 'zookeeper.upstart.erb'
      mode   '0644'
      variables(
        exec:     executable_path,
        username: username
      )
      cookbook template_cookbook
      notifies :restart, 'service[zookeeper]'
    end

    service 'zookeeper' do
      provider Chef::Provider::Service::Upstart
      supports status: true, restart: true
      action   service_actions
    end
  when 'sysv'
    template '/etc/init.d/zookeeper' do
      source 'zookeeper.sysv.erb'
      mode   '0755'
      variables(
        exec:     executable_path,
        username: username
      )
      cookbook template_cookbook
      notifies :restart, 'service[zookeeper]'
    end

    service_provider = value_for_platform_family(
      'rhel'    => Chef::Provider::Service::Init::Redhat,
      'default' => Chef::Provider::Service::Init::Debian
    )

    service 'zookeeper' do
      provider service_provider
      supports status: true, restart: true
      action   service_actions
    end
  when 'systemd'
    template '/etc/systemd/system/zookeeper.service' do
      source 'zookeeper.systemd.erb'
      mode   '0644'
      variables(
        exec:     executable_path,
        username: username
      )
      cookbook template_cookbook
      notifies :run, 'execute[systemctl daemon-reload]'
    end

    execute 'systemctl daemon-reload' do
      action :nothing
      command '/bin/systemctl daemon-reload'
      notifies :restart, 'service[zookeeper]'
    end

    service 'zookeeper' do
      provider Chef::Provider::Service::Systemd
      supports status: true, restart: true
      action   service_actions
    end

  when 'exhibitor'
    Chef::Log.info 'Assuming Exhibitor will start up Zookeeper.'
  end
end
