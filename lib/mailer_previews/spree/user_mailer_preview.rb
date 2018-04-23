module Spree
  class UserMailerPreview < ActionMailer::Preview
    def reset_password_instructions
      UserMailer.reset_password_instructions(User.first, 'token')
    end

    def welcome
      UserMailer.welcome(User.first.id)
    end

    def confirmation_instructions
      user = User.where(unconfirmed_email: nil).first
      UserMailer.confirmation_instructions(user, 'faketoken')
    end

    def reconfirmation_instructions
      user = User.first
      user.unconfirmed_email = 'newemail@public.market'
      UserMailer.confirmation_instructions(user, 'faketoken')
    end

    def email_change
      UserMailer.email_change(User.first.id)
    end
  end
end
