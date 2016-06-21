# recipes/config_render.rb
#
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

# set the config path based on default attributes
# render out our config
zookeeper_config 'zookeeper config' do
  conf_dir  node['zookeeper']['config_dir']
  conf_file node['zookeeper']['conf_file']
  config    node['zookeeper']['config']
  log_dir   node['zookeeper']['log_dir']
  user      node['zookeeper']['user']
  env_vars  node['zookeeper']['env_vars']
end
