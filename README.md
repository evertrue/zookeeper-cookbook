# zookeeper cookbook

[![Build Status](https://travis-ci.org/evertrue/zookeeper-cookbook.svg?branch=master)](https://travis-ci.org/evertrue/zookeeper-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/zookeeper.svg)](https://supermarket.chef.io/cookbooks/zookeeper)

**Table of Contents**

* [Zookeeper](#zookeeper)
    - [Usage](#usage)
        + [Resources](#resources)
            * [zookeeper](#zookeeper)
            * [zookeeper_config](#zookeeper_config)
    - [Errata](#errata)
    - [Author and License](#author-and-license)

## Apache ZooKeeper

[Apache ZooKeeper](http://zookeeper.apache.org/) is a coordination and discovery
service maintained by the Apache Software Foundation.

This cookbook focuses on deploying ZooKeeper via Chef.

### Usage

This cookbook is primarily a library cookbook. It implements a `zookeeper` and `zookeeper_config` 
resource to handle the installation and configuration of ZooKeeper. It ships
with a default recipe for backwards compatibility pre-LWRP which will work
fine, but is really just an example.

Testing is handled using Test Kitchen, with the expectation that you have it installed as part of the [Chef DK](https://downloads.chef.io/chef-dk/).

### Recipes

* `zookeeper::default` : Installs and configures ZooKeeper. This does not start or manage the service.
* `zookeeper::install` : Installs the ZooKeeper but does not configure it.
* `zookeeper::config_render` : Configures ZooKeeper but does not install it.
* `zookeeper::service` : Starts and manages the ZooKeeper service. Requires ZooKeeper to be installed/configured.

### Resources

This cookbook ships with two resources, with future plans for one more covering
service management.

#### zookeeper

The `zookeeper` resource is responsible for installing and (eventually)
uninstalling Zookeeper from a node.

Actions: `:install`, `:uninstall`

Parameters:

* `version`: Version of ZooKeeper to install (name attribute)
* `user`: The user who will eventually run Zookeeper (default: `'zookeeper'`)
* `user_home`: Path to the home folder for the Zookeeper user (default: `/home/zookeeper`)
* `mirror`: The mirror to obtain ZooKeeper from (required)
* `checksum`: Checksum for the ZooKeeper download file
* `install_dir`: Which directory to install Zookeeper to (default: `'/opt/zookeeper'`)

Example:

``` ruby
zookeeper '3.4.8' do
  user     'zookeeper'
  mirror   'http://www.poolsaboveground.com/apache/zookeeper'
  checksum 'f10a0b51f45c4f64c1fe69ef713abf9eb9571bc7385a82da892e83bb6c965e90'
  action   :install
end
```

#### zookeeper_config

This resource renders a ZooKeeper configuration file. Period-delimited
parameters can be specified either as a flat hash, or by embeddeding each
sub-section within a separate hash. See the example below for an example.

Actions: `:render`, `:delete`

Parameters:

* `user`: The user to give ownership of the file to (default: `zookeeper`)
* `config`: Hash of configuration parameters to add to the file
* `path`: Path to write the configuration file to.

Example:

``` ruby
config_hash = {
  clientPort: 2181, 
  dataDir: '/mnt/zk', 
  tickTime: 2000,
  autopurge: {
    snapRetainCount: 1,
    purgeInterval: 1
  }
}

zookeeper_config '/opt/zookeeper/zookeeper-3.4.8/conf/zoo.cfg' do
  config config_hash
  user   'zookeeper'
  action :render
end
```

#### zookeeper_node

This resource can create nodes in a running instance of ZooKeeper.

Actions: `:create`, `:create_if_missing`, `:delete`

Parameters:

* `path`: The ZooKeeper node path (default: The name of the resource)
* `connect_str`: The ZooKeeper connection string (required)
* `data`: The data to write to the node
* `auth_scheme`: The authentication scheme (default: digest)
* `auth_cert`: The authentication password or data
* `acl_digest`: Hash of acl permissions per 'digest' id
* `acl_ip`: Hash of acl permissions per 'ip'
* `acl_sasl`: Hash of acl permissions per 'sasl' id (SASLAuthentication provider must be enabled)
* `acl_world`: Acl permissions for anyone (default: `Zk::PERM_ALL`)

Example:

``` ruby
zookeeper_node '/data/myNode' do
  action       :create
  connect_str  "localhost:2181"
  data         "my data"
  auth_scheme  "digest"
  auth_cert    "user1:pwd1"
  acl_digest   "user1:a9l5yfb9zl8WCXjVmi5/XOC0Ep4=" => Zk::PERM_ALL
  acl_ip       "127.0.0.1" => Zk::PERM_READ | Zk::PERM_WRITE
  acl_sasl     "user@CHEF.IO" => Zk::PERM_ADMIN
  acl_world    Zk::PERM_NONE
end
```

## Errata

* Version 1.4.7 on the community site is in fact version 1.4.8.

## Author and License

EverTrue <devops@evertrue.com>  
Simple Finance <ops@simple.com>  
Apache License, Version 2.0
