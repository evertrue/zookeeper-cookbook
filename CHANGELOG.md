# CHANGELOG for zookeeper

This file is used to list changes made in each version of zookeeper.

* NOTE: An error was made in the past bumping this cookbook to 2.0.0. This was
  to support Runit for service management. The version was then brought down
  again to 1.7.1 and development has continued as normal. Therefore, version
  1.7.0 and above uses Runit and is likely not backwards-compatible. Apologies
  for the mess!

## 1.7.4
- Force build-essential to run at compile time (contributed by @davidgiesberg)

## 1.7.3
- Bugfix for attribute access (fixes 1.7.2 bug)

## 1.7.2
- Move ZK download location calculation to recipe to eliminate ordering bug

## 1.7.1
- Test-kitchen support added
- Patch installed to support CentOS platform

## 1.7.0
- Switched to Runit for process supervision (contributed by @gansbrest)
- DEPRECATION WARNING: Upstart is no longer supported and has been removed
- Re-add check-local-zk.py script but punt on utilizing it
- This means we recommend staying on 1.6.1 or below if you use Upstart
- In the meantime, we are working on a strategy to integrate this functionality
  into the Runit script, to support dependent services

## 1.6.0
- Attribute overrides to defaultconfig should now work (thank @trane)

## 1.5.1
- Add correct (Apache v2) license to metadta.rb (#61)

## 1.5.0
- Add logic to download existing exhibitor jar

## 1.4.10
- changes: Skip S3 credentials file if AWS credentials are not provided

### OpsWorks related changes
- Moved property files from inaccessible chef dir to exhibitor install dir.
- Logged output to syslog.
- Added option to set exhibitor/amazon log level

## 1.4.9
- Added: s3credentials template to assist with --configtype s3

## 1.4.8
- Added config hook and default for servers-spec setting
- bugfix: cache permission denied error on exhibitor jar move
- bugfix: ZooKeeper install tar cache EACCES error


## 1.4.7
- bugfix: zk_connect_str actually returned when chroot passed.
- forward zk port in vagrant

## 1.4.4

* fix for backwards compatibility with ruby 1.8.7


## 0.1.0:

* Initial release of zookeeper

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.
