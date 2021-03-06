RSpec.describe Spree::ShipmentMailer, type: :mailer do
  let(:order) { create(:order_with_vendor_items) }
  let(:shipment) { order.shipments.first }

  describe '#shipped_email' do
    let(:mail) { described_class.shipped_email(shipment) }

    it 'contains correct subject' do
      expect(mail.subject).to include('has been shipped')
    end

    it 'contains correct body' do
      expect(mail.body).to include('Your order is on its way!')
    end

    it 'container support url' do
      expect(mail.body).to include('/freshdesk')
    end

    it 'sends an email' do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end
end
