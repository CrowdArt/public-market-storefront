Spree::User.create!(
  email: Rails.application.credentials.test_seller_user_name,
  login: Rails.application.credentials.test_seller_user_name,
  password: Rails.application.credentials.test_seller_user_password,
  spree_api_key: Rails.application.credentials.test_seller_user_api_key,
  spree_roles: Spree::Role.where(name: 'user'),
  confirmed_at: Time.zone.now
)
