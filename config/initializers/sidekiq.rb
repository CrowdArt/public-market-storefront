require 'sidekiq'
require 'sidekiq/logging'

Sidekiq.configure_client do |config|
  config.redis = { size: 12, db: 14, host: ENV['REDIS_HOST'] }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 12, db: 14, host: ENV['REDIS_HOST'] }
end

module Sidekiq
  module Logging
    # override existing log to include the arguments passed to `perform`
    def self.job_hash_context(job_hash)
      # If we're using a wrapper class, like ActiveJob, use the "wrapped"
      # attribute to expose the underlying thing.
      klass = job_hash['wrapped'.freeze] || job_hash['class'.freeze]
      bid = job_hash['bid'.freeze]
      args = job_hash['args'.freeze]
      "#{klass} #{" ARGS-#{args}" if args} JID-#{job_hash['jid'.freeze]}#{" BID-#{bid}" if bid}"
    end
  end
end
