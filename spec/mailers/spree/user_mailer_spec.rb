RSpec.describe Spree::UserMailer, type: :mailer do
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
      expect(mail.subject).to include I18n.t('emails.reset_password_instructions.subject')
    end

    it 'contains correct body' do
      expect(mail.body).to include('Reset your password')
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
      expect(mail.subject).to include I18n.t('emails.confirmation.subject')
    end

    it 'contains correct body' do
      expect(mail.body).to include('Just one step away from verifying your Public Market account')
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
    let(:mail) { described_class.email_change(user.id, 'old@email.ru') }

    it 'is sent to correct email' do
      expect(mail.to).to eq ['old@email.ru']
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
