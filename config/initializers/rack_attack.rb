if Rails.env.production? || Rails.env.staging?
  module Rack
    class Attack
      throttle('throttle_authenticated', limit: 14, period: 1.second) do |req|
        req.ip if req.env['warden'].user && !req.path.starts_with?('/assets') && !req.path.starts_with?('/sidekiq')
      end

      throttle('throttle_unauthenticated', limit: 7, period: 1.second) do |req|
        req.ip if !req.env['warden'].user && !req.path.starts_with?('/assets')
      end
    end
  end
end
