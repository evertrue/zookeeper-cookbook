require 'chefspec'
require 'chefspec/berkshelf'

RSpec.configure do |config|
  config.platform  = 'ubuntu'
  config.version   = '16.04'
  config.color     = true
  config.formatter = :documentation
end

at_exit { ChefSpec::Coverage.report! }
