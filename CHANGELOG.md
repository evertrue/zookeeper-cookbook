# CHANGELOG for zookeeper

This file is used to list changes made in each version of zookeeper.

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
