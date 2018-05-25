RSpec.describe Spree::OrderMailer, type: :mailer do
  let(:order) { create(:order_with_line_items) }

  before do
    allow(Spree::Vendor).to receive(:first) { build_stubbed(:vendor) }
    stub_current_store
  end

  describe '#confirm_email' do
    let(:mail) { described_class.confirm_email(order) }

    it 'contains correct subject' do
      expect(mail.subject).to include('has been confirmed')
    end

    it 'contains correct body' do
      expect(mail.body).to include('Please review and retain the following order information for your records.')
    end

    it 'user name from billing address' do
      expect(mail.body).to include(order.billing_address.first_name)
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

  describe '#cancel_email' do
    let(:order) { build_stubbed(:order_with_line_items) }
    let(:mail) { described_class.cancel_email(order) }

    it 'contains correct subject' do
      expect(mail.subject).to include('could not be filled')
    end

    it 'contains correct body' do
      expect(mail.body).to include('vendor is unable to fill this order.')
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
