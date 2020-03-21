name             'zookeeper'
maintainer       'EverTrue'
maintainer_email 'devops@evertrue.com'
license          'Apache-2.0'
description      'Installs/Configures zookeeper'
version          '12.0.1'

issues_url 'https://github.com/evertrue/zookeeper-cookbook/issues'
source_url 'https://github.com/evertrue/zookeeper-cookbook/'

supports         'ubuntu', '>= 16.04'
supports         'centos', '~> 7.0'
supports         'oracle', '~> 7.0'
supports         'redhat', '~> 7.0'

chef_version     '>= 13.0'

depends          'build-essential', '>= 5.0'
depends          'java', '>= 1.39'
depends          'runit', '>= 1.7'
depends          'magic', '>= 1.1'
depends          'ark', '>= 1.0'
