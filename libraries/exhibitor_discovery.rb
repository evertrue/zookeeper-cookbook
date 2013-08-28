#
# Cookbook Name:: exhibitor_discovery
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
#


require 'net/http'
require 'uri'

class ExhibitorError < StandardError
end


def discover_zookeepers(exhibitor_host)
    require 'json'
    url = URI.join(exhibitor_host, '/exhibitor/v1/cluster/list')
    begin
      http = Net::HTTP.new(url.host, url.port)
      http.read_timeout = http.open_timeout = 3
      JSON.parse(http.get(url.path).body)
    rescue StandardError => reason
      raise ExhibitorError, reason
    end
end

def zk_connect_str(zookeepers, chroot = nil)
  # zookeepers: as returned from discover_zookeepers
  # chroot: optional chroot
  #
  # returns a zk connect string as used by kafka, and others
  # host1:port,...,hostN:port[/<chroot>]

  zk_connect = zookeepers["servers"].collect { |server| "#{server}:#{zookeepers['port']}" }.join ","
  if not chroot.nil?
    zk_connect += "/#{chroot}"
  end
  zk_connect
end
