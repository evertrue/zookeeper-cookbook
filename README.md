# zookeeper cookbook

[![Build Status](https://travis-ci.org/evertrue/zookeeper-cookbook.svg?branch=master)](https://travis-ci.org/evertrue/zookeeper-cookbook)
[![Cookbook Version](https://img.shields.io/cookbook/v/zookeeper.svg)](https://supermarket.chef.io/cookbooks/zookeeper)

**Table of Contents**

* [Zookeeper](#zookeeper)
    - [Usage](#usage)
        + [Resources](#resources)
            * [zookeeper](#zookeeper)
            * [zookeeper_config](#zookeeper_config)
            * [zookeeper_service](#zookeeper_service)
            * [zookeeper_node](#zookeeper_node)
    - [Errata](#errata)
    - [Author and License](#author-and-license)

## Apache ZooKeeper

[Apache ZooKeeper](http://zookeeper.apache.org/) is a coordination and discovery
service maintained by the Apache Software Foundation.

This cookbook focuses on deploying ZooKeeper via Chef.

It should be noted that ZooKeeper’s configuration and startup systems are complicated. To elaborate, the service scripts supplied by this cookbook use `bin/zkServer.sh` inside the ZooKeeper directory, which sources a variety of shell scripts as part of its initialization process.

Please be mindful if you decide to install ZooKeeper to a different location that the path to the config directory should remain pointed to the one within the install directory, unless you instead to completely rewire how ZooKeeper runs in your wrapper cookbook.

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

#### `zookeeper`

The `zookeeper` resource is responsible for installing and (eventually)
uninstalling Zookeeper from a node.

Actions: `:install`, `:uninstall`

Parameters:

* `version`: Version of ZooKeeper to install (name attribute)
* `username`: The user who will eventually run Zookeeper (default: `'zookeeper'`)
* `user_home`: Path to the home folder for the Zookeeper user (default: `/home/zookeeper`)
* `mirror`: The mirror to obtain ZooKeeper from (required)
* `checksum`: Checksum for the ZooKeeper download file
* `install_dir`: Which directory to install Zookeeper to (default: `'/opt/zookeeper'`)

Example:

``` ruby
zookeeper '3.4.8' do
  username 'zookeeper'
  mirror   'http://www.poolsaboveground.com/apache/zookeeper'
  checksum 'f10a0b51f45c4f64c1fe69ef713abf9eb9571bc7385a82da892e83bb6c965e90'
  action   :install
end
```

#### `zookeeper_config`

This resource renders a ZooKeeper configuration file.

Actions: `:render`, `:delete`

Parameters:

* `conf_file` (name attribute): Base name of the config file
* `conf_dir`: Path to write the configuration file to (defaults to `/opt/zookeeper/conf`)
* `config`: Hash of configuration parameters to add to the file
  - Defaults to:
```ruby
{
  'clientPort' => 2181,
  'dataDir'    => '/var/lib/zookeeper',
  'tickTime'   => 2000,
  'initLimit'  => 5,
  'syncLimit'  => 2
}
```
* `env_vars`: Hash of startup environment variables (defaults to `{}`)
* `log_dir`: Log directory (defaults to `/var/log/zookeeper`)
* `user`: The user to give ownership of the file to (default: `zookeeper`)

Example:

``` ruby
config_hash = {
  clientPort: 2181,
  dataDir: '/mnt/zk',
  tickTime: 2000,
  'autopurge.snapRetainCount' => 1,
  'autopurge.purgeInterval' => 1
  }
}

zookeeper_config 'zoo.cfg' do
  config config_hash
  user   'zookeeper'
  action :render
end
```

#### `zookeeper_service`

This resource manages a system service for ZooKeeper. Confusingly, it has only one action, and the resources within are controlled via a property.

This will change in a future release, but is “good enough” for now.

Actions: `:create`

Properties:

* `service_style`: The type of service provider you wish to use. Defaults to `runit`, and only allows one of the following:
    - `runit`
    - `upstart`
    - `systemd`
    - `exhibitor`
* `install_dir`: Where you’ve installed ZooKeeper (defaults to `/opt/zookeeper`)
* `username`: The user to run ZooKeeper under (defaults to `zookeeper`)
* `service_actions`: The actions to pass in to the service resource within this custom resource (defaults to `[:enable, :start]`)
* `template_cookbook`: The name of the cookbook to use for the service templates. Allows you to override the service script created & used (defaults to `zookeeper`, i.e., this cookbook)
* `restart_on_reconfig`: Whether or not to restart this service on changes to the service script (defaults to `false`)

Example:

```ruby
zookeeper_service 'zookeeper' do
  service_style 'systemd'
  install_dir   '/opt/zookeeper'
  username      'zookeeper'
end
```

#### `zookeeper_node`

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
