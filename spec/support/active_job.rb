RSpec.configure do |config|
  config.include ActiveJob::TestHelper

  config.before { clear_enqueued_jobs }
end
