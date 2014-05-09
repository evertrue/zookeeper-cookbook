Description
===========
Installs and configures ZooKeeper.

Requirements
============
java

Errata
======

- version 1.4.7 on the community site is in fact version 1.4.8. The result of
of duplicating information.

Attributes
==========

- zookeeper[:version] - ZooKeeper version to use. Default "3.4.5"
- zookeeper[:mirror] - URI to ZooKeeper tarball, defaults to ibiblio mirror using `zookeeper[:version]`
- zookeeper[:checksum] - Checksum of ZooKeeper tarball, must match source
- zookeeper[:install_dir] - Where to install ZooKeeper. Default "/opt/zookeeper"
- zookeeper[:user] - ZooKeeper user. Default "zookeeper"
- zookeeper[:group] - ZooKeeper group. Default "zookeeper"
