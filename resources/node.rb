#
# Cookbook Name:: zookeeper
# Resource:: node

# Copyright 2013, Simple Finance Technology Corp.
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

default_action :create

property :node_path,   String, name_attribute: true
property :connect_str, String, required: true, desired_state: false
property :data,        String

property :auth_cert,   [String, nil], default: nil,      desired_state: false
property :auth_scheme,                default: 'digest', desired_state: false

property :acl_digest,  Hash,   default: {}
property :acl_ip,      Hash,   default: {}
property :acl_sasl,    Hash,   default: {}
property :acl_world,   Integer, default: Zk::PERM_ALL

include Zk::Gem

load_current_value do
  result = zk.get_acl path: node_path
  current_value_does_not_exist! unless result[:stat].exists

  data zk.get(path: node_path)[:data]

  result[:acl].each do |acl|
    case acl[:id][:scheme]
    when 'world'
      acl_world acl[:perms]
    else
      send("acl_#{acl[:id][:scheme]}")[acl[:id][:id]] = acl[:perms]
    end
  end
end

action :create_if_missing do
  run_action :create unless current_value
end

action :create do
  converge_if_changed do
    if current_value
      if current_value.data != new_resource.data
        converge_by "Updating #{new_resource.node_path} node" do
          result = zk.set(path: new_resource.node_path, data: new_resource.data)[:rc]

          raise "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result == 0
        end
      end

      if [
        :acl_world,
        :acl_digest,
        :acl_ip,
        :acl_sasl,
      ].any? { |s| current_value.send(s) != new_resource.send(s) }
        converge_by "Setting #{new_resource.node_path} acls" do
          result = zk.set_acl(path: new_resource.node_path, acl: compile_acls)[:rc]

          raise "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result == 0
        end
      end
    else
      converge_by "Creating #{new_resource.node_path} node" do
        result = zk.create(path: new_resource.node_path, data: new_resource.data, acl: compile_acls)[:rc]

        raise "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result == 0
      end
    end
  end
end

action :delete do
  converge_by "Removing #{new_resource.node_path} node" do
    zk.delete path: new_resource.node_path
  end
end
