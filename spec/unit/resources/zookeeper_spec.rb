require 'spec_helper'

describe 'zookeeper' do
  step_into :zookeeper
  platform 'ubuntu'

  context 'with default properties' do
    automatic_attributes['memory']['total'] = 2048

    recipe do
      zookeeper 'zookeeper' do
        use_java_cookbook false
      end
    end

    it { is_expected.to install_ark('zookeeper') }
  end
end
