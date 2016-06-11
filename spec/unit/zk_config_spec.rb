#
# Cookbook Name:: zookeeper
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'
require_relative '../../libraries/default.rb'

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
    expected = "clientPort=2181\ntickTime=2000\ndataDir=/opt/zookeeper/mydatadir\n"

    expect(render_zk_config(@flat_config)).to eq expected
  end

  it 'should render a multi-level hash correctly' do
    expected = "clientPort=2181\
\ntickTime=2000\ndataDir=/opt/zookeeper/mydatadir\n\
autopurge.snapRetainCount=3\nautopurge.purgeInterval=1\n"

    expect(render_zk_config(@embedded_config)).to eq expected
  end
end
