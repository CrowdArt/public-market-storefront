if Rails.env.production? || Rails.env.staging?
  module Rack
    class Attack
      throttle('req/ip', limit: 5, period: 1.second) do |req|
        # If the return value is truthy, the cache key for the return value
        # is incremented and compared with the limit. In this case:
        #   "rack::attack:#{Time.now.to_i/1.second}:req/ip:#{req.ip}"
        #
        # If falsy, the cache key is neither incremented nor checked.

        req.ip unless req.path.starts_with?('/assets') || req.path.starts_with?('/sidekiq')
      end
    end
  end
end
