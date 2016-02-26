# coding: UTF-8

require 'spec_helper'

context 'when node[zookeeper][service_style] is set to sysv on CentOS' do
  describe file '/etc/init.d/zookeeper' do
    it { is_expected.to be_file }
  end

  describe service 'zookeeper' do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running }
  end
end
