require 'tzinfo'

def local(time)
  TZInfo::Timezone.get('US/Pacific').local_to_utc(Time.parse(time)) # rubocop:disable Rails/TimeZone
end

set :output, '/var/log/cron.log'
set :environment, ENV['RAILS_ENV']
env :GEM_HOME, ENV['BUNDLE_PATH']
env :BUNDLE_WITHOUT, ENV['BUNDLE_WITHOUT']
env :DB_HOST, ENV['DB_HOST']

every 1.day, at: local('05:00 am') do
  if ENV['RAILS_ENV'] == 'production'
    rake 'sitemap:refresh'
  else
    rake 'sitemap:refresh:no_ping'
  end
end
