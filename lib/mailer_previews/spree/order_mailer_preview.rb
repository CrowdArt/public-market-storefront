module Spree
  class OrderMailerPreview < ActionMailer::Preview
    def confirm_email
      OrderMailer.confirm_email(Order.last)
    end
  end
end
