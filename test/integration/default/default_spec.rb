describe service 'zookeeper' do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

describe 'zookeeper_config' do
  describe file '/etc/zookeeper/conf/zoo.cfg' do
    it { should be_file }
    its('owner') { should eq 'zookeeper' }
    its('group') { should eq 'zookeeper' }

    its('content') do
      should include 'clientPort=2181'
      should include 'tickTime=2000'
      should include 'initLimit=5'
      should include 'syncLimit=2'
      should include 'dataDir=/var/lib/zookeeper'
    end
  end

  describe file '/etc/zookeeper/conf/zookeeper-env.sh' do
    it { should be_file }
    its('owner') { should eq 'zookeeper' }
    its('group') { should eq 'zookeeper' }

    its('content') do
      should include 'ZOOCFGDIR=/etc/zookeeper/conf'
      should include 'ZOOCFG=zoo.cfg'
      should include 'ZOO_LOG_DIR=/var/log/zookeeper'
    end
  end
end
