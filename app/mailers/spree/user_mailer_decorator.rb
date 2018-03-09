Spree::UserMailer.class_eval do
  def welcome(user_id)
    user = Spree::User.find(user_id)
    @home_url = spree.root_url

    mail_template(user, :welcome, root_url: spree.root_url)
  end

  def confirmation_instructions(user, token, _opts = {})
    confirmation_url = spree.spree_user_confirmation_url(confirmation_token: token)

    mail_template(user, :confirmation, confirmation_url: confirmation_url)
  end
end
