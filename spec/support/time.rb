RSpec.configure do |config|
  config.include ActiveSupport::Testing::TimeHelpers

  config.after do
    travel_back
  end
end
