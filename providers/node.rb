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
  require 'zookeeper'

  @zookeeper ||= begin
    ::Zookeeper.new(@new_resource.connect_str)
  end
end

action :create_if_missing do
  unless zookeeper.stat(:path => @new_resource.path)[:stat].exists?
    zookeeper.create(:path => @new_resource.path, :data => @new_resource.data)
  end
end

action :create do
  if !@new_resource.collection.nil?
    @new_resource.collection.each_pair { | key, value |
        if zookeeper.stat(:path => @new_resource.path + "/" + key)[:stat].exists?
            zookeeper.set(:path => @new_resource.path + "/" + key, :data => value)
                else
                    zookeeper.create(:path => @new_resource.path + "/" + key, :data => value)
                end
        }
  else
      if zookeeper.stat(:path => @new_resource.path)[:stat].exists?
        zookeeper.set(:path => @new_resource.path, :data => @new_resource.data)
      else
        zookeeper.create(:path => @new_resource.path, :data => @new_resource.data)
      end
  end
end

action :delete do
  zookeeper.delete(:path => @new_resource.path)
end
