require 'spree/testing_support/controller_requests'

module SpreeBookstoreHelpers
  def stub_current_store
    allow(Spree::Store).to receive(:current) { build_stubbed(:store) }
  end
end

RSpec.configure do |config|
  config.include SpreeBookstoreHelpers
end
