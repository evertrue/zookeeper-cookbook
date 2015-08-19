# providers/node.rb
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

def zookeeper
  @zookeeper ||= ::Zookeeper.new(new_resource.connect_str).tap do |zk|
    zk.add_auth(scheme: new_resource.auth_scheme, cert: new_resource.auth_cert) unless new_resource.auth_cert.nil?
  end
end

use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  require 'zookeeper'

  result = zookeeper.stat(path: new_resource.path)
  return unless result[:stat].exists

  @current_resource = Chef::Resource::ZookeeperNode.new new_resource.name
  @current_resource.data zookeeper.get(path: new_resource.path)[:data]
end

action :create_if_missing do
  run_action :create unless @current_resource
end

action :create do
  if @current_resource.nil?
    converge_by "Creating #{new_resource.path} node" do
      zookeeper.create path: new_resource.path, data: new_resource.data
    end
  else
    converge_by "Updating #{new_resource.path} node" do
      zookeeper.set path: new_resource.path, data: new_resource.data
    end if @current_resource.data != new_resource.data
  end
end

action :delete do
  converge_by "Removing #{new_resource.path} node" do
    zookeeper.delete(path: new_resource.path)
  end if @current_resource
end
