require 'vcr'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/cassettes'
  c.hook_into :webmock
  c.ignore_hosts '127.0.0.1', '0.0.0.0', 'localhost', 'elasticsearch'
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    allow_playback_repeats: true
  }

  secrets = YAML.load_file('config/settings/test.yml')
  c.filter_sensitive_data('<BTOL_USER>') { secrets['btol_user'] }
  c.filter_sensitive_data('<BTOL_PASSWORD>') { secrets['btol_password'] }
end
