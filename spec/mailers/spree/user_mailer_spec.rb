RSpec.describe Spree::UserMailer, type: :mailer do
  before { stub_current_store }

  describe '#welcome' do
    let(:user) { create(:user) }
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
    let(:user) { build_stubbed(:user) }
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
    let(:user) { build_stubbed(:user) }
    let(:mail) { described_class.confirmation_instructions(user, 'token') }

    it 'is sent to correct email' do
      expect(mail.to).to eq [user.email]
    end

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

    context 'when reconfirmation' do
      let(:user) { build_stubbed(:user, unconfirmed_email: 'hey@public.market') }

      it 'is sent to correct email' do
        expect(mail.to).to eq [user.unconfirmed_email]
      end

      it 'contains correct subject' do
        expect(mail.subject).to include('Confirm to change')
      end

      it 'contains correct body' do
        expect(mail.body).to include('change the email address associated with your account')
        expect(mail.body).to include(user.unconfirmed_email)
      end
    end
  end

  describe '#email_change' do
    let(:user) { create(:user) }
    let(:mail) { described_class.email_change(user.id) }

    it 'is sent to correct email' do
      expect(mail.to).to eq [user.email]
    end

    it 'contains correct subject' do
      expect(mail.subject).to include('Email Address Changed')
    end

    it 'contains correct body' do
      expect(mail.body).to include('request to change the email address')
    end

    it 'sends an email' do
      expect {
        mail.deliver_now
      }.to change(ActionMailer::Base.deliveries, :size).by(1)
    end
  end
end
