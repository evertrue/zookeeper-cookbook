!/usr/bin/env ruby

version = 'ubuntu-12.04'
box = "opscode-#{version}"
url = "https://opscode-vm.s3.amazonaws.com/vagrant/opscode_#{box}_provisionerless.box"
Vagrant.configure('2') do |config|
  config.vm.hostname = 'COOKBOOK'
  config.vm.box = box
  config.vm.box_url = url
  config.omnibus.chef_version = :latest
  config.vm.network :forwarded_port, guest: 8080, host: 8080

  config.vm.provision :chef_solo do |chef|
    chef.json = {}
    chef.run_list = [
      'recipe[zookeeper::default]'
    ]
  end
end
