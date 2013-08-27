#!/usr/bin/env ruby

box = ENV['VAGRANT_BOX'] || 'opscode_ubuntu-12.04_provisionerless'
Vagrant.configure('2') do |config|
  config.vm.hostname = 'zookeeper'
  config.vm.box = box
  config.vm.box_url = "https://opscode-vm.s3.amazonaws.com/vagrant/#{box}.box"
  config.omnibus.chef_version = :latest
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.network :forwarded_port, guest: 2181, host: 2181

  config.vm.provision :shell do |shell|
    shell.inline = 'test -f $1 || (sudo apt-get update -y && touch $1)'
    shell.args = '/var/run/apt-get-update'
  end

  config.vm.provision :chef_solo do |chef|
    chef.run_list = [
      'recipe[zookeeper::default]'
    ]
  end
end
