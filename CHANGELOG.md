# CHANGELOG for zookeeper
This file is used to list changes made in each version of zookeeper.

## 3.0.1
* Run apt-get update at compile time
* Use lazy evaluation for `config_dir` (#153, h/t to @Maniacal)
* Update to testing using Chef 12.x
    - Works around the fact that Serverspec requires a version of net-ssh that needs Ruby >= 2.0

## 3.0.0
* Fix setting of `CLASSPATH` to have version dynamically set
* Upgrade to ZooKeeper 3.4.7, due to the disappearance of ZK 3.4.6 at the chosen mirror
    - Upgrading ZK is potentially breaking

## 2.13.1
* Switch to using `value_for_platform_family()` to determine the SysV service script provider to use
    - Makes the cookbook less restrictive w/r/t using it on a RHEL-based OS

## 2.13.0
* Improve generally for better CentOS support (#146)
* Create ZooKeeper log dir on installation (#147)
* Add SysV support for CentOS systems not using Upstart/Runit/Exhibitor
* Fix testing by dropping usage of Chef Zero
    - Not sure why Chef Zero won’t work, but it’d be nice to get it going again
    - Seems to complain about not being able to find something w/r/t the tester cookbook

## 2.12.0
* Add ability to configure znode ACL via node LWRP (#145 thanks @Annih)
* Create zookeeper user as system user (#142 thanks @petere)
* Update to prelease `runit` cookbook b/c of a bug in that cookbook
    - Soon as the next release of it is cut, we can revert e371719
* Switch to chef-zero for the Test Kitchen provisioner

## 2.11.0
* Fix logic around creating `zookeeper-env.sh` (Fixes #141)
* Add tests for default attribtues & using `node[:zookeeper][:env_vars]`
* Add JAVA_OPTS attribute (#144, thanks @andrewgoktepe)

## 2.10.0
* Move creation of `zookeeper-env.sh` to `zookeeper::install`, to allow cookbooks that only call that recipe (e.g., [`exhibitor`](https://github.com/SimpleFinance/cookbook-exhibitor))
* Relax permissions on ZK install_dir (#140)

## 2.9.0
* Add creation & configuration of `zookeeper-env.sh`, an optional file to bring in custom EnvVars for Zookeeper to use
* Fix typo in source for SysV init script (#139)

## 2.8.0
* Proper init support (contributed by @shaneramey)

## 2.7.0
* Add some tests
* Fix up zookeeper_node
* Call runit recipe before service declaration

## 2.6.0
* Run apt::default and update at compille time if on Debian (#127)

## 2.5.1
* Report `zookeeper_config` as updated only if zoo.cfg is updated (#110)
* Fix `zk_installed` return value (#113)
* Fix docs (#114, #115)
* Fix for undefined new method error (#116)
* Always install `build-essential`, regardless of usage of `java` cookbook

## 2.5.0
* Allow configurable `data_dir` parameter for Zookeeper data directory location
  (contributed by @eherot)

## 2.4.3
* Fix erroneous attribute reference

## 2.4.2
* Allow pre-installed Java (contributed by @solarce)

## 2.4.1
* Fixed recipe call (contributed by @solarce)

## 2.4.0
* Split out config rendering to separate recipe (contributed by @solarce)

## 2.3.0
* Split out installation to a separate recipe (contributed by @Gazzonyx)

## 2.2.1
* Set minimum build-essential version for RHEL support (contributed by
  @Gazzonyx)

## 2.2.0
* Upstart support (contributed by @solarce)

## 2.1.1
* Added a service recipe which can be run and activated using new service_style
  attribute.

## 2.1.0
* A basic configuration is rendered by default.
* Clarify some points in the README about zookeeper\_config

## 2.0.0
* Exhibitor cookbook factored out (contributed by @wolf31o2)
* Zookeeper recipe rewritten as LWRP
* Documentation updated slightly
* Tested and verified and (hopefully) as backwards-compatible as possible
  - Being a full version bump, there are no backwards-compatibility promises
* TODO
  - Better documentation
  - `zookeeper_service` resource
  - `zookeeper_config` resource
  - Better tests
  - Swap out "community" Java

## 1.7.4
* Force build-essential to run at compile time (contributed by @davidgiesberg)

## 1.7.3
* Bugfix for attribute access (fixes 1.7.2 bug)

## 1.7.2
* Move ZK download location calculation to recipe to eliminate ordering bug

## 1.7.1
* Test-kitchen support added
* Patch installed to support CentOS platform

## 1.7.0
* Switched to Runit for process supervision (contributed by @gansbrest)
* DEPRECATION WARNING: Upstart is no longer supported and has been removed
* Re-add check-local-zk.py script but punt on utilizing it
* This means we recommend staying on 1.6.1 or below if you use Upstart
* In the meantime, we are working on a strategy to integrate this functionality
  into the Runit script, to support dependent services

## 1.6.0
* Attribute overrides to defaultconfig should now work (contributed by @trane)

## 1.5.1
* Add correct (Apache v2) license to metadta.rb (#61)

## 1.5.0
* Add logic to download existing exhibitor jar

## 1.4.10
* changes: Skip S3 credentials file if AWS credentials are not provided

### OpsWorks related changes
* Moved property files from inaccessible chef dir to exhibitor install dir.
* Logged output to syslog.
* Added option to set exhibitor/amazon log level

## 1.4.9
* Added: s3credentials template to assist with --configtype s3

## 1.4.8
* Added config hook and default for servers-spec setting
* bugfix: cache permission denied error on exhibitor jar move
* bugfix: ZooKeeper install tar cache EACCES error

## 1.4.7
* bugfix: zk_connect_str actually returned when chroot passed.
* forward zk port in vagrant

## 1.4.4

* fix for backwards compatibility with ruby 1.8.7

## 0.1.0:

* Initial release of zookeeper
