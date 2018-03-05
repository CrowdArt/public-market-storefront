require 'sidekiq'

Sidekiq.configure_client do |config|
  config.redis = { size: 12, db: 14, host: ENV['REDIS_HOST'] }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 12, db: 14, host: ENV['REDIS_HOST'] }
end
