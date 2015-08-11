# coding: UTF-8

require 'spec_helper'

describe service('zookeeper') do
  it { should be_running }
end

describe port(2181) do
  it { should be_listening }
end

describe 'zookeeper_node' do
  it 'should create /testing' do
    zookeeper = Zookeeper.new 'localhost:2181'
    data = zookeeper.get path: '/testing'
    expect(data[:stat].exists?).to eq true
    expect(data[:data]).to eq 'some data'
  end
end

describe file '/opt/zookeeper/zookeeper-3.4.6/conf/zookeeper-env.sh' do
  it { should be_file }
  describe '#content' do
    subject { super().content }
    it { should include 'ZOO_LOG4J_PROP=INFO,ROLLINGFILE' }
    it { should include 'ZOO_LOG_DIR=/var/log/zookeeper' }
  end
end
