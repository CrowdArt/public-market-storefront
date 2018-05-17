module Spree
  class OrderMailerPreview < ActionMailer::Preview
    def confirm_email
      OrderMailer.confirm_email(Order.joins(:ship_address).last)
    end

    def cancel_email
      OrderMailer.cancel_email(Order.joins(:ship_address).last)
    end
  end
end
