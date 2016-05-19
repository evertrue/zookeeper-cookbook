name             'zookeeper'
maintainer       'Simple Finance Technology Corp.'
maintainer_email 'ops@simple.com'
license          'Apache v2.0'
description      'Installs/Configures zookeeper'
version          '5.0.1'

issues_url 'https://github.com/evertrue/zookeeper-cookbook/issues' if respond_to?(:issues_url)
source_url 'https://github.com/evertrue/zookeeper-cookbook/' if respond_to?(:source_url)

supports         'ubuntu', '= 12.04'
supports         'ubuntu', '= 14.04'
supports         'centos', '= 6.5'

depends          'build-essential', '~> 2.2'
depends          'java', '~> 1.39'
depends          'runit', '~> 1.7'
depends          'apt'
depends          'magic', '~> 1.1'
