RSpec.configure do |config|
  config.before { ActionMailer::Base.deliveries.clear }
end
