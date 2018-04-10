require 'mixpanel-ruby'

::Tracker = Mixpanel::Tracker.new(Settings.mixpanel_api_key)

# if Rails.env.development?
#   Mixpanel.config_http do |http|
#     http.verify_mode = OpenSSL::SSL::VERIFY_NONE
#   end
# end
