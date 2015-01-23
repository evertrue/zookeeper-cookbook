# test/unit/config_spec.rb

require_relative '../spec/spec_helper'

describe Zk::Config do
  include Zk::Config

  before do
    @flat_config = {
      clientPort: 2181,
      tickTime: 2000,
      dataDir: '/opt/zookeeper/mydatadir'
    }

    @embedded_config = {
      clientPort: 2181,
      tickTime: 2000,
      dataDir: '/opt/zookeeper/mydatadir',
      autopurge: {
        snapRetainCount: 3,
        purgeInterval: 1
      }
    }
  end

  it 'should render a flat hash correctly' do
    output = render_zk_config(@flat_config)
    expected = "clientPort=2181\ntickTime=2000\ndataDir=/opt/zookeeper/mydatadir\n"

    assert_equal(expected, output)
  end

  it 'should render a multi-level hash correctly' do
    output = render_zk_config(@embedded_config)
    expected = "clientPort=2181\
\ntickTime=2000\ndataDir=/opt/zookeeper/mydatadir\n\
autopurge.snapRetainCount=3\nautopurge.purgeInterval=1\n"

    assert_equal(expected, output)
  end
end
