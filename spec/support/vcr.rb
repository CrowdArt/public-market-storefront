require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.ignore_hosts '127.0.0.1', '0.0.0.0', 'localhost', 'elasticsearch'
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    allow_playback_repeats: true
  }

  if Rails.application.credentials.bowker_user
    c.filter_sensitive_data('<BOWKER_AUTH>') {
      Base64.encode64(Rails.application.credentials.bowker_user + ':' + Rails.application.credentials.bowker_password).strip
    }
  end

  c.filter_sensitive_data('<STRIPE_SECRET>') { Rails.application.credentials.stripe_secret_key }
  c.filter_sensitive_data('<STRIPE_PUB>') { Rails.application.credentials.stripe_publishable_key }
end

RSpec.configure do |config|
  config.around(:each, vcr: true, vcr_proxy: true) do |example|
    ENV['http_proxy'] = VCR.current_cassette.nil? || VCR.current_cassette.recording? ? 'http://staging.public.market:3000' : ''
    example.run
    ENV['http_proxy'] = nil
  end
end
