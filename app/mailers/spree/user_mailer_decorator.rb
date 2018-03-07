Spree::UserMailer.class_eval do
  def welcome(user_id)
    user = Spree::User.find(user_id)
    @home_url = spree.root_url

    mail_template(user, :welcome, root_url: spree.root_url)
  end
end
