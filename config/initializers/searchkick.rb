Searchkick.redis = Redis.new(host: ENV['REDIS_HOST'])
Searchkick.index_suffix = ENV['TEST_ENV_NUMBER'] if Rails.env.test?
