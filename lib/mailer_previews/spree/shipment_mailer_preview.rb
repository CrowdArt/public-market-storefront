module Spree
  class ShipmentMailerPreview < ActionMailer::Preview
    def shipped_email
      ShipmentMailer.shipped_email(Shipment.where(tracking: nil).first)
    end

    def shipped_email_with_tracking
      ShipmentMailer.shipped_email(Shipment.where.not(tracking: nil).first)
    end
  end
end
