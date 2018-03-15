module Spree
  class ShipmentMailerPreview < ActionMailer::Preview
    def shipped_email
      ShipmentMailer.shipped_email(Shipment.last)
    end
  end
end
