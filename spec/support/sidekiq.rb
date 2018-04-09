require 'sidekiq/testing'

RSpec.configure do |config|
  config.before do
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
  end
end
