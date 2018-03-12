require 'spec_helper'
ENV['RAILS_ENV'] = 'test'
require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'test/scenario_flows'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false
  config.infer_spec_type_from_file_location!
  config.fixture_path = Rails.root.join('spec', 'fixtures')

  config.include Test::ScenarioFlows, type: :feature
end
