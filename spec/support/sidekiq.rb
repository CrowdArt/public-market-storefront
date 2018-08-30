require 'sidekiq/testing'

RSpec.configure do |config|
  config.around(:each, enqueue: true) do |example|
    ActiveJob::Base.queue_adapter = :test
    ActiveJob::Base.queue_adapter.enqueued_jobs.clear
    example.run
    ActiveJob::Base.queue_adapter = :inline
  end
end
