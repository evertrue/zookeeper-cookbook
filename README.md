# zookeeper cookbook

![ci](https://github.com/evertrue/zookeeper-cookbook/workflows/ci/badge.svg)
[![Cookbook Version](https://img.shields.io/cookbook/v/zookeeper.svg)](https://supermarket.chef.io/cookbooks/zookeeper)

## Table of Contents

* [zookeeper cookbook](#zookeeper-cookbook)
  * [Table of Contents](#table-of-contents)
  * [Apache ZooKeeper](#apache-zookeeper)
    * [Resources](#resources)
      * [`zookeeper`](#zookeeper)
      * [`zookeeper_config`](#zookeeper_config)
      * [`zookeeper_service`](#zookeeper_service)
  * [Errata](#errata)
  * [Author and License](#author-and-license)

## Apache ZooKeeper

[Apache ZooKeeper](http://zookeeper.apache.org/) is a coordination and discovery
service maintained by the Apache Software Foundation.

This cookbook focuses on deploying ZooKeeper via Chef.

It should be noted that ZooKeeper’s configuration and startup systems are complicated. To elaborate, the service scripts supplied by this cookbook use `bin/zkServer.sh` inside the ZooKeeper directory, which sources a variety of shell scripts as part of its initialization process.

Please be mindful if you decide to install ZooKeeper to a different location that the path to the config directory should remain pointed to the one within the install directory, unless you instead to completely rewire how ZooKeeper runs in your wrapper cookbook.

### Resources

#### `zookeeper`

The `zookeeper` resource is responsible for installing and (eventually)
uninstalling Zookeeper from a node.

Actions: `:install`, `:uninstall`

Parameters:

* `version`: Version of ZooKeeper to install
* `username`: The user who will eventually run Zookeeper (default: `'zookeeper'`)
* `user_home`: Path to the home folder for the Zookeeper user (default: `/home/zookeeper`)
* `mirror`: The mirror to obtain ZooKeeper from (required)
* `checksum`: Checksum for the ZooKeeper download file
* `install_dir`: Which directory to install Zookeeper to (default: `'/opt/zookeeper'`)
* `java_version`: The version of OpenJDK to install.
  * Alternatively, set `use_java_cookbook false`, and manage your Java installation yourself

Example:

``` ruby
zookeeper 'zookeeper' do
  version  '3.4.8'
  username 'zookeeper'
  mirror   'http://www.poolsaboveground.com/apache/zookeeper'
  checksum 'f10a0b51f45c4f64c1fe69ef713abf9eb9571bc7385a82da892e83bb6c965e90'
  action   :install
end
```

#### `zookeeper_config`

This resource renders a ZooKeeper configuration file.

Actions: `:create`, `:delete`

Parameters:

* `conf_file` (name attribute): Base name of the config file
* `conf_dir`: Path to write the configuration file to (defaults to `/opt/zookeeper/conf`)
* `config`: Hash of configuration parameters to add to the file
  * Defaults to:

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
* `username`: The user to give ownership of the file to (default: `zookeeper`)

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
  username 'zookeeper'
  action :create
end
```

#### `zookeeper_service`

This resource manages a system service for ZooKeeper. Confusingly, it has only one action, and the resources within are controlled via a property.

This will change in a future release, but is “good enough” for now.

Actions: `:create`

Properties:

* `service_style`: The type of service provider you wish to use. Defaults to `systemd`, and only allows one of the following:
  * `systemd`
  * `exhibitor`
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

## Errata

* Version 1.4.7 on the community site is in fact version 1.4.8.

## Author and License

* Jeff Byrnes <thejeffbyrnes@gmail.com>
* EverTrue <devops@evertrue.com>
* Simple Finance <ops@simple.com>

Apache License, Version 2.0
