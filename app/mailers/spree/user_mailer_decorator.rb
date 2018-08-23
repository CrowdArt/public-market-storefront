Spree::UserMailer.class_eval do
  def welcome(user_id)
    user = Spree::User.find(user_id)

    mail_template(user, :welcome, root_url: spree.root_url)
  end

  def reset_password_instructions(user, token, _opts = {})
    edit_password_reset_url = spree.edit_spree_user_password_url(reset_password_token: token)

    mail_template(user, :reset_password_instructions, edit_password_reset_url: edit_password_reset_url)
  end

  def confirmation_instructions(user, token, _opts = {})
    confirmation_url = spree.spree_user_confirmation_url(confirmation_token: token)

    template, user_email =
      if user.pending_reconfirmation?
        [:reconfirmation, user.unconfirmed_email]
      else
        [:confirmation, user.email]
      end

    mail_template(user_email, template, email: user_email, confirmation_url: confirmation_url)
  end

  def email_change(user_id, old_email)
    user = Spree::User.find(user_id)
    mail_template(old_email, :email_change, first_name: user.first_name)
  end
end
