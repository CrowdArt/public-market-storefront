Spree::UserMailer.class_eval do
  def welcome(user_id)
    user = Spree::User.find(user_id)

    mail_template(user, :welcome, root_url: spree.root_url(host: Spree::Store.current.url))
  end

  def reset_password_instructions(user, token, _opts = {})
    edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token, host: Spree::Store.current.url)

    mail_template(user, :reset_password_instructions, edit_password_reset_url: edit_password_reset_url)
  end

  def confirmation_instructions(user, token, _opts = {})
    confirmation_url = spree.spree_user_confirmation_url(confirmation_token: token, host: Spree::Store.current.url)

    mail_template(user, :confirmation, confirmation_url: confirmation_url)
  end
end
