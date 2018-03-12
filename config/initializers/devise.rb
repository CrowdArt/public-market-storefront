Devise.secret_key = Settings.secret_key_base

Devise.setup do |config|
  config.password_length = 8..50
  config.reconfirmable = true
end
