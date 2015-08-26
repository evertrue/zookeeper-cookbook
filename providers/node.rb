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

use_inline_resources

def whyrun_supported?
  true
end

def load_current_resource
  require 'zookeeper'

  result = zookeeper.get_acl(path: new_resource.path)
  return unless result[:stat].exists

  @current_resource = Chef::Resource::ZookeeperNode.new new_resource.name
  @current_resource.data zookeeper.get(path: new_resource.path)[:data]

  result[:acl].each do |acl|
    case acl[:id][:scheme]
      when 'world'
        @current_resource.acl_world acl[:perms]
      else
        @current_resource.send("acl_#{acl[:id][:scheme]}".to_sym)[acl[:id][:id]] = acl[:perms]
    end
  end
end

action :create_if_missing do
  run_action :create unless @current_resource
end

action :create do
  if @current_resource.nil?
    converge_by "Creating #{new_resource.path} node" do
      result = zookeeper.create(path: new_resource.path, data: new_resource.data, acl: compile_acls)[:rc]
      fail "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result.zero?
    end
  else
    converge_by "Updating #{new_resource.path} node" do
      result = zookeeper.set(path: new_resource.path, data: new_resource.data)[:rc]
      fail "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result.zero?
    end if @current_resource.data != new_resource.data

    converge_by "Setting #{new_resource.path} acls" do
      result = zookeeper.set_acl(path: new_resource.path, acl: compile_acls)[:rc]
      fail "Failed with error code '#{result}' => (#{::Zk.error_message result})" unless result.zero?
    end if [:acl_world, :acl_digest, :acl_ip, :acl_sasl].any? { |s| @current_resource.send(s) != new_resource.send(s) }
  end
end

action :delete do
  converge_by "Removing #{new_resource.path} node" do
    zookeeper.delete(path: new_resource.path)
  end if @current_resource
end

private

def zookeeper
  @zookeeper ||= ::Zookeeper.new(new_resource.connect_str).tap do |zk|
    zk.add_auth(scheme: new_resource.auth_scheme, cert: new_resource.auth_cert) unless new_resource.auth_cert.nil?
  end
end

def compile_acls
  @compiled_acls ||= [].tap do |acls|
    acls << ::Zookeeper::ACLs::ACL.new(id: { id: 'anyone', scheme: 'world' }, perms: new_resource.acl_world)

    %w(digest ip sasl).each do |scheme|
      new_resource.send("acl_#{scheme}".to_sym).each do |id, perms|
        acls << ::Zookeeper::ACLs::ACL.new(id: { scheme: scheme, id: id }, perms: perms)
      end
    end
  end
end
