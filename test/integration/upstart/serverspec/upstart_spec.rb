# coding: UTF-8

require 'spec_helper'

context 'when node[zookeeper][service_style] is set to upstart on Ubuntu' do
  describe file '/etc/init/zookeeper.conf' do
    it { is_expected.to be_file }
  end

  describe service 'zookeeper' do
    it { is_expected.to be_enabled }
    it { is_expected.to be_running.under 'upstart' }
  end
end
