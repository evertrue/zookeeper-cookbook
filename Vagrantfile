#!/usr/bin/env ruby
# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.omnibus.chef_version = :latest
  config.vm.box = "opscode_ubuntu-12.04_chef-11.2.0"
  config.vm.network :forwarded_port, guest: 8080, host: 8080
  config.vm.provision :chef_solo do |chef|
    chef.add_recipe "apt"
    chef.add_recipe "zookeeper"
  end
end
