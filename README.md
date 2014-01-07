Description
===========
Installs and configures ZooKeeper and Exhibitor.

Requirements
============
java

Errata
======

- version 1.4.7 on the community site is in fact version 1.4.8. The result of
of duplicating information.

Attributes
==========
To override exhibitor command line options, add them to node[:exhibitor][:opts].
See https://github.com/Netflix/exhibitor/wiki/Running-Exhibitor for more detauls

:snapshot_dir, :transaction_dir: and :log_index_dir in node[:exhibitor] should be set to something sane.
Linkedin recommend putting snapshots and logs on a different device than transactions for a write-heavy workload.
https://cwiki.apache.org/confluence/display/KAFKA/Operations#Operations-OperationalizingZookeeper

node[:exhibitor][:defaultconfig] contains config that exhibitor will be initialized with.
See https://github.com/Netflix/exhibitor/wiki/Configuration-UI and 
https://github.com/Netflix/exhibitor/wiki/Running-Exhibitor under *Default Property Names*.

Usage
=====

discover_zookeepers
-------------------

This cookbook comes with a library to help your other cookbooks discovery the members of your ZooKeeper ensamble.
Call it with the host of (one) of your exhibitors. We use round-robin dns so it would look like

    > discover_zookeepers("http://exhibitor.example.com:8080")
    {"servers":["10.0.1.0","10.0.1.1","10.0.1.2"],"port":2181}

for details on the response format, see https://github.com/Netflix/exhibitor/wiki/REST-Entities under Servers
