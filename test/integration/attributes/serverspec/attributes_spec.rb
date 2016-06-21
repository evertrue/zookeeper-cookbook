# coding: UTF-8

require 'spec_helper'

context 'when node[zookeeper][env_vars] attribute is set' do
  describe file '/opt/zookeeper/conf/zookeeper-env.sh' do
    it { should be_file }
    describe '#content' do
      subject { super().content }
      it { should include 'ZOO_LOG4J_PROP=INFO,ROLLINGFILE' }
    end
  end
end
