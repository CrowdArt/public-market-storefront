RSpec.describe Spree::UserMailer, type: :mailer do
  let(:user) { create(:user) }

  before { stub_current_store }

  describe '#welcome' do
    let(:mail) { described_class.welcome(user.id) }

    it 'contains correct subject' do
      expect(mail.subject).to include('Welcome to Public Market')
    end

    it 'contains correct body' do
      expect(mail.body).to include('Welcome to Fair Commerce')
    end

    it 'sends an email' do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  describe '#reset_password_instructions' do
    let(:mail) { described_class.reset_password_instructions(user, 'token') }

    it 'contains correct subject' do
      expect(mail.subject).to include('Recover your account')
    end

    it 'contains correct body' do
      expect(mail.body).to include('Forgot your password?')
    end

    it 'sends an email' do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end

  describe '#confirmation_instructions' do
    let(:mail) { described_class.confirmation_instructions(user, 'token') }

    it 'contains correct subject' do
      expect(mail.subject).to include('Verify your email & activate your account')
    end

    it 'contains correct body' do
      expect(mail.body).to include('Just one step away from joining Public Market')
    end

    it 'sends an email' do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end
end
