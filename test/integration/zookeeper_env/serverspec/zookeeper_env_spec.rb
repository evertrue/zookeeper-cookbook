# coding: UTF-8

require 'spec_helper'

context 'when node[:zookeeper][:env_vars] is set' do
  describe file '/opt/zookeeper/zookeeper-3.4.8/conf/zookeeper-env.sh' do
    it { should be_file }
    describe '#content' do
      subject { super().content }
      it { should include 'ZOO_LOG4J_PROP=INFO,ROLLINGFILE' }
      it { should include 'ZOO_LOG_DIR=/var/log/zookeeper' }
    end
  end
end
