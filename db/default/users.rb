Spree::User.create!(
  email: Settings.admin_name,
  login: Settings.admin_name,
  password: Settings.admin_password,
  spree_roles: Spree::Role.where(name: 'admin')
)

Spree::User.create!(
  email: Settings.test_seller_user_name,
  login: Settings.test_seller_user_name,
  password: Settings.test_seller_user_password,
  spree_api_key: Settings.test_seller_user_api_key,
  spree_roles: Spree::Role.where(name: 'user')
)
