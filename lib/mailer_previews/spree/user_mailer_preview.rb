module Spree
  class UserMailerPreview < ActionMailer::Preview
    def reset_password_instructions
      UserMailer.reset_password_instructions(User.first, 'token')
    end

    def welcome
      UserMailer.welcome(User.first.id)
    end

    def confirmation_instructions
      UserMailer.confirmation_instructions(User.first, 'faketoken')
    end
  end
end
