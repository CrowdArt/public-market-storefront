Spree::UserMailer.class_eval do
    def welcome(user)
      @home_url = spree.root_url

      mail to: user.email, from: from_address
    end
end
