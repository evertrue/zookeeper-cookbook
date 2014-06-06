**Table of Contents**

- [Zookeeper](#zookeeper)
  - [Usage](#usage)
    - [discover\_zookeepers](#discover\_zookeepers)
  - [Errata](#errata)
  - [Author and License](#author-and-license)

# Zookeeper
[Zookeeper](http://zookeeper.apache.org/) is a coordination and discovery
service maintained by the Apache Software Foundation.

This cookbook focuses on deploying Zookeeper via Chef.

## Usage
This cookbook is a library cookbook. It implements a `zookeeper` resource to
handle the installation and configuration of Zookeeper.

### discover\_zookeepers
This cookbook comes with a library to help your other cookbooks discovery the members of your ZooKeeper ensamble.
Call it with the host of (one) of your exhibitors. We use round-robin dns so it would look like

    > discover_zookeepers("http://exhibitor.example.com:8080")
    {"servers":["10.0.1.0","10.0.1.1","10.0.1.2"],"port":2181}

for details on the response format, see https://github.com/Netflix/exhibitor/wiki/REST-Entities under Servers

## Errata
* Version 1.4.7 on the community site is in fact version 1.4.8.

## Author and License
Simple Finance <ops@simple.com>
Apache License, Version 2.0
