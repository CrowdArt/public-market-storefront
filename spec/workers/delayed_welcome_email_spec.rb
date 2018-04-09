RSpec.describe DelayedWelcomeEmail, type: :worker do
  subject(:worker) { described_class.new }

  let(:user) { create(:user, confirmed_at: nil) }

  before { stub_current_store }

  describe '#perform' do
    it 'sends welcome email' do
      expect {
        worker.perform(user.id)
      }.to have_enqueued_job(ActionMailer::DeliveryJob).with('Spree::UserMailer', 'welcome', 'deliver_now', user.id)
    end

    context 'when is confirmed' do
      let(:user) { create(:user, confirmed_at: Time.current) }

      it "doesn't send welcome email" do
        expect {
          worker.perform(user.id)
        }.not_to have_enqueued_job(ActionMailer::DeliveryJob).with('Spree::UserMailer', 'welcome', 'deliver_now', user.id)
      end
    end
  end
end
