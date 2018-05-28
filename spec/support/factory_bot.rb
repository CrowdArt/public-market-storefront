require 'factory_bot'
require 'ffaker'
require 'spree/testing_support/factories'
require 'spree_multi_vendor/factories'

RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:suite) do
    FactoryBot.find_definitions
  end
end
