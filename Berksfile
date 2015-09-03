source 'https://supermarket.chef.io'

metadata

cookbook 'runit', github: 'hw-cookbooks/runit', ref: 'ee15ff5'

group :integration do
  cookbook 'zookeeper_tester', path: 'test/cookbooks/zookeeper_tester'
end
