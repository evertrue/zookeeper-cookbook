# coding: UTF-8

require 'spec_helper'

context 'when all attributes are default' do
  describe service('zookeeper') do
    it { should be_running }
  end

  describe port(2181) do
    it { should be_listening }
  end

  describe 'zookeeper_config' do
    describe file '/opt/zookeeper/conf/zoo.cfg' do
      it { should be_file }
      describe '#content' do
        subject { super().content }
        it { should include 'clientPort=2181' }
        it { should include 'tickTime=2000' }
        it { should include 'initLimit=5' }
        it { should include 'syncLimit=2' }
        it { should include 'dataDir=/var/lib/zookeeper' }
      end
    end
  end

  describe file '/opt/zookeeper/conf/zookeeper-env.sh' do
    it { should be_file }
    describe '#content' do
      subject { super().content }
      it { should include 'ZOOCFGDIR=/opt/zookeeper/conf' }
      it { should include 'ZOOCFG=zoo.cfg' }
      it { should include 'ZOO_LOG_DIR=/var/log/zookeeper' }
    end
  end

  describe 'zookeeper_node' do
    it 'should create /testing' do
      zookeeper = Zookeeper.new 'localhost:2181'
      data = zookeeper.get path: '/testing'
      expect(data[:stat].exists?).to eq true
      expect(data[:data]).to eq 'some data'
    end

    it 'should create /secure with correct ACLs' do
      expected_acls = [
        { perms: 31, id: { scheme: 'digest', id: 'user1:a9l5yfb9zl8WCXjVmi5/XOC0Ep4=' } },
        { perms: 3, id: { scheme: 'ip', id: '127.0.0.1' } },
        { perms: 0, id: { scheme: 'world', id: 'anyone' } }
      ]

      zookeeper = Zookeeper.new 'localhost:2181'
      result = zookeeper.get_acl path: '/secure'
      expect(result[:stat].exists?).to eq true
      expect(result[:acl]).to match_array expected_acls
    end
  end
end
