# This migration comes from spree_auth (originally 20180413125034)
class AddDeviseTwoFactorToUsers < ActiveRecord::Migration[4.2]
  def change
    add_column :spree_users, :encrypted_otp_secret, :string
    add_column :spree_users, :encrypted_otp_secret_iv, :string
    add_column :spree_users, :encrypted_otp_secret_salt, :string
    add_column :spree_users, :consumed_timestep, :integer
    add_column :spree_users, :otp_required_for_login, :boolean
  end
end
