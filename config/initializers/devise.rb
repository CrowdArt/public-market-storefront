Devise.secret_key = '89778def80e850bf38a60f4b56537e14a3aef4bb11c38e5db4a00976e9a22979c8144d89fb8c82fc732fd6ba016e4dfe62be'

Devise.setup do |config|
  config.password_length = 8..20
end
