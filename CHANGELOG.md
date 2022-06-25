# CHANGELOG for zookeeper

This file is used to list changes made in each version of zookeeper.

## 14.0.0

* Drop Chef 13 support; it is EOL as of April 2020
* Make `username` property consistent across resources (#226)
* Upgrade to `java` cookbook v8.x
  * Necessitates upgrade to Java 11 by default
* Drop `port` test b/c it is inconsistent in its results

## 13.0.0

* Install ZooKeeper 3.6.1 by default
* Drop Chef 13 support b/c it has been EOL for 2 years
  * Pin `java < 7.0.0` to maintain Chef 14 support
* Add testing on Ubuntu 20.04 & CentOS 8
  * Remove the `zookeeper_node` resource, b/c it depends on the zookeeper gem, which has not had a new release since 2015
* Follow through on long-standing deprecation notice & remove all recipes, making this a resource-only cookbook
  * Rewrite unit tests to do the most basic testing of the `zookeeper` resource
* Drop support for runit & upstart in favor of SystemD
* Use the `systemd_unit` resource available since Chef 12.11

## 12.0.1

* Duplicate `acl_#{scheme}` for Chef 14+ compatibility (#222 h/t @kamaradclimber)
* Drop deprecated key `sudo` from Travic CI test config
* Fix metadata to reflect that Chef 12 support has been missing for some time, as it has been EOL for over a year
* Bring back testing on Chef 13 until we officially drop support

## v12.0.0

* Upgrade to ZooKeeper v3.4.14
* Clean up unit testing to work with current Chef tools
* Run Test Kitchen using Chef 14 & 15
* Drop EOL Ubuntu 14.04 support

## v11.1.0

* Fix compile failure in node resource (#217 h/t @tas50)
* Update/fix for Chef 13/14 (#217 h/t @tas50)

## v11.0.0

* Set default version to ZooKeeper 3.4.12 (#216)
  * This may upgrade you if you are using `zookeeper::default` and have not set `node['zookeeper']['version']` in your wrapper cookbook

## v10.0.1

* Update README to reflect lack of SysV support (#214)

## v10.0.0

* Set default version to ZooKeeper 3.4.11 (#208)
  * This may upgrade you if you are using `zookeeper::default` and have not set `node['zookeeper']['version']` in your wrapper cookbook
* Drop support for:
  * Ubuntu 12.04
  * CentOS 6
  * SysV as a service provider
* Source `zookeeper-env.sh` when running ZooKeeper (#210)
  * This allows for placing all of the configs somewhere other than the default
* Duplicate an immutable property in Chef 13 (#207)
* Fix file ownership (#209)
* Ensure config directory exists (for cases where using non-default)
* Make resources Chef 13 compatible
* Refactor Test Kitchen setup to use `kitchen-dokken` for simpler, more consistent testing across local & CI
* Switch to testing on Chef 13
* Clean up unit tests & metadata
* Add & update docs in README

## v9.0.1

* Clarify changelog w/r/t v8.3.0/v8.3.1

## v9.0.0

* Bump to major-level, owing to possibility of someone managing multiple ZooKeepers with this cookbook, and thus depending on the connection-per-`zookeeper_node`-resource that was the behavior previous to v8.3.0
  * h/t to @GolubevV for [mentioning this](https://github.com/evertrue/zookeeper-cookbook/pull/205#issuecomment-338639001)

## v8.3.1

* Roll back v8.3.0 to avoid potentially breaking changes

## v8.3.0

* Use class variable to avoid creating new connection for each resource (#205 h/t @GolubevV)

## v8.2.0

* Add new property to `zookeeper_service` to restart on changes to its config (h/t @jaybocc2 #200)

## v8.1.3

* Fix misnamed attribute
  * Lost in the shuffle long ago!

## v8.1.2

* Ensure the /opt/zookeeper-$version directory is owned by zookeeper:zookeeper (#196)

## v8.1.1

* Update checksum to match that of version 3.4.9 (fixes #194)
* Actually test sending checksum in attributes to `zookeeper` resource when setting up test instance (Relates to #194)
* In `zookeeper` resource, `if property_is_set? new_resource.checksum` always returns false. Use `if new_resource.checksum` instead.

## v8.1.0

* **NOTICE** Install zookeeper 3.4.9

* Make sure java_opts is actually rendered in the ZK env config

## v8.0.1

* Correct missed change of `user` to `username` in SysV script template (#189 h/t @d601)

## v8.0.0

* Loosen dependencies’ pins to all be `>=`, (#187 #188 h/t @Stromweld)

## v7.1.1

* Fix order of operations re: `link[/opt/zookeeper]` (a sub-unit of the `ark[zookeeper]` resource) (#183, @Stromweld)

## v7.1.0

* Add SystemD support

## v7.0.0

* Completely refactor existing LWRPs into Chef 12.5 Custom Resources
* Refactor `zookeeper::service` into a Custom Resource (#86)
* Drop `apt` cookbook in favor of built-in resources in Chef >= 12.11
* Migrate all logic inside resources
* Use `ark` to download & install ZooKeeper, rather than handling every resource directly
  * This is almost _certainly_ a breaking change, as it moves where ZooKeeper is installed by default
  * Advantage: a symlink is created at `/#{install_dir}/zookeeper`, pointing to `/#{install_dir}/zookeeper-#{version}`, so handling paths to the current install is far easier
  * Caution: `/#{install_dir}/zookeeper` has been, until now, a container directory for any installations of ZooKeeper (e.g., `/#{install_dir}/zookeeper/zookeeper-#{version}`)
* Refactor recipes to wrap resources
  * An attempt at backwards compatibility has been made, using the previous attribute-driven style
  * These attributes & recipes will be dropped in future, as per a deprecation notice added to `zookeeper::default`

* Add more tests in an attempt at being comprehensive of various ways this cookbook can be used

## v6.0.0

* Drop separate `environment-defaults` file for Upstart/SysV in favor of using same env vars as Runit
  * Consistency is key
* Use `zkServer.sh` for all service scripts
* Drop pinning for `build-essential`
* Rewire how env vars are used to correctly set the config & log locations
  * Default values added to set the config & log paths properly

* Set Upstart & SysV services to `action: [:enable, :start]` to match the Runit service

* Pass values into Upstart & SysV init scripts, rather than directly using attributes
* Drop any Minitest unit tests in favor of ChefSpec

## v5.0.2

* Update to working Apache mirror (#170 #178)

## v5.0.1

* Drop pinning of apt cookbook to avoid transitive depsolving pain

## v5.0.0

### Breaking

* Use java-cookbook-installed version of Java by way of the `$JAVA_HOME` env var

* Ensure `zookeeper-env.sh` gets the correct values:
  * Properly set `node[zookeeper][config_dir]` with lazy interpolation of the `node[zookeeper][version]` attribute
  * Use lazy evaluation for `exports_config`
* Export some env vars for subshelled SysV-run services

### Other changes

* Add proper testing suite using RuboCop, Foodcritic, ChefSpec, and Test Kitchen, automated w/ Travis CI
* Pin dependency versions to avoid breaking changes being introduced from upstream

## v4.1.0

* Add ability to configure JMX port & local only settings via attributes (#172 @felka)

## v4.0.0

* Upgrade to ZooKeeper 3.4.8

## v3.0.6

* Add `initLimit` and `syncLimit` to ZooKeeper config (#171)

## v3.0.5

* Use `node[zookeeper][user]` attribute consistently
* Fix user for runit-managed service style (#166 #167)

## v3.0.4

* Add missing `user_home` attribute to `zookeeper` resource

## v3.0.3

* Ensure `zookeeper` user has a home folder (#163, #164)

## v3.0.2

* Roll back to version 3.4.6 as per a [deadlock issue](https://issues.apache.org/jira/browse/ZOOKEEPER-2347) found by @eherot on #156

## v3.0.1

* Run apt-get update at compile time
* Use lazy evaluation for `config_dir` (#153, h/t to @Maniacal)
* Update to testing using Chef 12.x
  * Works around the fact that Serverspec requires a version of net-ssh that needs Ruby >= 2.0

## v3.0.0

* Fix setting of `CLASSPATH` to have version dynamically set
* Upgrade to ZooKeeper 3.4.7, due to the disappearance of ZK 3.4.6 at the chosen mirror
  * Upgrading ZK is potentially breaking

## v2.13.1

* Switch to using `value_for_platform_family()` to determine the SysV service script provider to use
  * Makes the cookbook less restrictive w/r/t using it on a RHEL-based OS

## v2.13.0

* Improve generally for better CentOS support (#146)
* Create ZooKeeper log dir on installation (#147)
* Add SysV support for CentOS systems not using Upstart/Runit/Exhibitor
* Fix testing by dropping usage of Chef Zero
  * Not sure why Chef Zero won’t work, but it’d be nice to get it going again
  * Seems to complain about not being able to find something w/r/t the tester cookbook

## v2.12.0

* Add ability to configure znode ACL via node LWRP (#145 thanks @Annih)
* Create zookeeper user as system user (#142 thanks @petere)
* Update to prelease `runit` cookbook b/c of a bug in that cookbook
  * Soon as the next release of it is cut, we can revert e371719
* Switch to chef-zero for the Test Kitchen provisioner

## v2.11.0

* Fix logic around creating `zookeeper-env.sh` (Fixes #141)
* Add tests for default attributes & using `node[zookeeper][env_vars]`
* Add JAVA_OPTS attribute (#144, thanks @andrewgoktepe)

## v2.10.0

* Move creation of `zookeeper-env.sh` to `zookeeper::install`, to allow cookbooks that only call that recipe (e.g., [`exhibitor`](https://github.com/SimpleFinance/cookbook-exhibitor))
* Relax permissions on ZK install_dir (#140)

## v2.9.0

* Add creation & configuration of `zookeeper-env.sh`, an optional file to bring in custom EnvVars for Zookeeper to use
* Fix typo in source for SysV init script (#139)

## v2.8.0

* Proper init support (contributed by @shaneramey)

## v2.7.0

* Add some tests
* Fix up zookeeper_node
* Call runit recipe before service declaration

## v2.6.0

* Run apt::default and update at compille time if on Debian (#127)

## v2.5.1

* Report `zookeeper_config` as updated only if zoo.cfg is updated (#110)
* Fix `zk_installed` return value (#113)
* Fix docs (#114, #115)
* Fix for undefined new method error (#116)
* Always install `build-essential`, regardless of usage of `java` cookbook

## v2.5.0

* Allow configurable `data_dir` parameter for Zookeeper data directory location
  (contributed by @eherot)

## v2.4.3

* Fix erroneous attribute reference

## v2.4.2

* Allow pre-installed Java (contributed by @solarce)

## v2.4.1

* Fixed recipe call (contributed by @solarce)

## v2.4.0

* Split out config rendering to separate recipe (contributed by @solarce)

## v2.3.0

* Split out installation to a separate recipe (contributed by @Gazzonyx)

## v2.2.1

* Set minimum build-essential version for RHEL support (contributed by
  @Gazzonyx)

## v2.2.0

* Upstart support (contributed by @solarce)

## v2.1.1

* Added a service recipe which can be run and activated using new `service_style`
  attribute.

## v2.1.0

* A basic configuration is rendered by default.
* Clarify some points in the README about `zookeeper_config`

## v2.0.0

* Exhibitor cookbook factored out (contributed by @wolf31o2)
* Zookeeper recipe rewritten as LWRP
* Documentation updated slightly
* Tested and verified and (hopefully) as backwards-compatible as possible
  * Being a full version bump, there are no backwards-compatibility promises
* TODO
  * Better documentation
  * `zookeeper_service` resource
  * `zookeeper_config` resource
  * Better tests
  * Swap out "community" Java

## v1.7.4

* Force build-essential to run at compile time (contributed by @davidgiesberg)

## v1.7.3

* Bugfix for attribute access (fixes 1.7.2 bug)

## v1.7.2

* Move ZK download location calculation to recipe to eliminate ordering bug

## v1.7.1

* Test-kitchen support added
* Patch installed to support CentOS platform

## v1.7.0

* Switched to Runit for process supervision (contributed by @gansbrest)
* DEPRECATION WARNING: Upstart is no longer supported and has been removed
* Re-add check-local-zk.py script but punt on utilizing it
* This means we recommend staying on 1.6.1 or below if you use Upstart
* In the meantime, we are working on a strategy to integrate this functionality
  into the Runit script, to support dependent services

## v1.6.0

* Attribute overrides to defaultconfig should now work (contributed by @trane)

## v1.5.1

* Add correct (Apache v2) license to metadta.rb (#61)

## v1.5.0

* Add logic to download existing exhibitor jar

## v1.4.10

* changes: Skip S3 credentials file if AWS credentials are not provided

### OpsWorks related changes

* Moved property files from inaccessible chef dir to exhibitor install dir.
* Logged output to syslog.
* Added option to set exhibitor/amazon log level

## v1.4.9

* Added: s3credentials template to assist with --configtype s3

## v1.4.8

* Added config hook and default for servers-spec setting
* bugfix: cache permission denied error on exhibitor jar move
* bugfix: ZooKeeper install tar cache EACCES error

## v1.4.7

* bugfix: zk_connect_str actually returned when chroot passed.
* forward zk port in vagrant

## v1.4.4

* fix for backwards compatibility with ruby 1.8.7

## v0.1.0

* Initial release of zookeeper
