RSpec.describe Spree::OrderMailer, type: :mailer do
  let(:order) { create(:order_with_line_items) }

  before do
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

    it 'sends an email' do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end
end
