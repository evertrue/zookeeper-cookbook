**Table of Contents**

- [Zookeeper](#zookeeper)
  - [Usage](#usage)
    - [Resources](#resources)
      - [zookeeper](#zookeeper)
    - [discover\_zookeepers](#discover\_zookeepers)
  - [Errata](#errata)
  - [Author and License](#author-and-license)

# Zookeeper
[Zookeeper](http://zookeeper.apache.org/) is a coordination and discovery
service maintained by the Apache Software Foundation.

This cookbook focuses on deploying Zookeeper via Chef.

## Usage
This cookbook is primarily a library cookbook. It implements a `zookeeper`
resource to handle the installation and configuration of Zookeeper. It ships
with a default recipe for backwards compatibility pre-LWRP which will work
fine, but is really just an example.

### Resources
This cookbook ships with one resource, with future plans for two more covering
service management and configuration rendering.

#### zookeeper
The `zookeeper` resource is responsible for installing and (eventually)
uninstalling Zookeeper from a node.

Actions: `:install`, `:uninstall`

Parameters:
* `version`: Version of Zookeeper to install (name attribute)
* `user`: The user who will eventually run Zookeeper (default: `'zookeeper'`)
* `mirror`: The mirror to obtain Zookeeper from (required)
* `checksum`: Checksum for the Zookeeper download file
* `install_dir`: Which directory to install Zookeeper to (default:
  `'/opt/zookeeper')

Example:
``` ruby
zookeeper '3.4.6' do
  user 'zookeeper'
  mirror 'http://www.poolsaboveground.com/apache/zookeeper'
  checksum '01b3938547cd620dc4c93efe07c0360411f4a66962a70500b163b59014046994'
  action :install
end
```

### discover\_zookeepers
This cookbook comes with a library to help your other cookbooks discovery the members of your ZooKeeper ensemble.
Call it with the host of (one) of your exhibitors. We use round-robin dns so it would look like

    > discover_zookeepers("http://exhibitor.example.com:8080")
    {"servers":["10.0.1.0","10.0.1.1","10.0.1.2"],"port":2181}

for details on the response format, see https://github.com/Netflix/exhibitor/wiki/REST-Entities under Servers

## Errata
* Version 1.4.7 on the community site is in fact version 1.4.8.

## Author and License
Simple Finance <ops@simple.com>
Apache License, Version 2.0
