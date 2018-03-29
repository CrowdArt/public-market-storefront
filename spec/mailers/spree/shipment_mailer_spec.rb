require 'rails_helper'

RSpec.describe Spree::ShipmentMailer, type: :mailer do
  let(:shipment) { create(:pm_shipment) }

  before do
    stub_current_store
  end

  describe '#shipped_email' do
    let(:mail) { described_class.shipped_email(shipment) }

    it 'contains correct subject' do
      expect(mail.subject).to include('has been shipped')
    end

    it 'contains correct body' do
      expect(mail.body).to include('Your order is on its way!')
    end

    it 'sends an email' do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end
end
