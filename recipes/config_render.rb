# recipes/config_render.rb
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

# set the config path based on default attributes
config_path = ::File.join(node[:zookeeper][:install_dir],
                          "zookeeper-#{node[:zookeeper][:version]}",
                          'conf')

zoo_cfg = ::File.join config_path, 'zoo.cfg'

# render out our config
zookeeper_config zoo_cfg do
  config node[:zookeeper][:config]
  user   node[:zookeeper][:user]
  action :render
end

# Add optional Zookeeper environment vars
if node[:zookeeper][:env_vars]
  zookeeper_env = ::File.join config_path, 'zookeeper-env.sh'

  file zookeeper_env do
    owner node[:zookeeper][:user]
    content exports_config node[:zookeeper][:env_vars]
  end
end
