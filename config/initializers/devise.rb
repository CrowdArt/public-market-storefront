ENV['OTP_SECRET'] ||= Rails.application.credentials.otp_secret

Devise.secret_key = Rails.application.credentials.secret_key_base || 'abcd'

Devise.setup do |config|
  config.password_length = 8..50
  config.reconfirmable = true
  config.authentication_keys = %i[username]
end
