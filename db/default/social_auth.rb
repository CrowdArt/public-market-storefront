%i[facebook google_oauth2].each do |provider|
  p "Seeding #{provider}"

  Spree::AuthenticationMethod.where(environment: Rails.env, provider: provider).first_or_create! do |auth_method|
    auth_method.api_key = Rails.application.credentials["#{provider}_api_key"]
    auth_method.api_secret = Rails.application.credentials["#{provider}_api_secret"]
    auth_method.active = true
  end
end
