RSpec.describe Spree::User, type: :model do
  describe 'validates names' do
    subject do
      build_stubbed(:user, first_name: first_name)
    end

    let(:first_name) { 'valid name' }

    it { is_expected.to be_valid }

    context 'with dash in name' do
      let(:first_name) { 'Sklodovskaya-Curie' }

      it { is_expected.to be_valid }
    end

    context 'with unicode letters in name' do
      let(:first_name) { 'Argüello' }

      it { is_expected.to be_valid }
    end

    context 'with numbers in name' do
      let(:first_name) { 'Richard 5th' }

      it { is_expected.not_to be_valid }
    end

    context 'with <script> in name' do
      let(:first_name) { '<script>' }

      it { is_expected.not_to be_valid }
    end

    context 'with &#10; in name' do
      let(:first_name) { '&#10;' }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'validates password length' do
    subject do
      build_stubbed(:user, password: password)
    end

    context 'with correct password' do
      let(:password) { FFaker::Internet.password(8, 8) }

      it { is_expected.to be_valid }
    end

    context 'with too short password' do
      let(:password) { FFaker::Internet.password(2, 2) }

      it { is_expected.not_to be_valid }
    end
  end

  describe 'set first & last name from shipping address' do
    let!(:user) { create(:user, first_name: nil, last_name: nil) }

    before { user.update(ship_address: create(:address)) }

    it { expect(user.first_name).not_to be_nil }
  end

  describe 'username' do
    subject { user.username }

    let(:user) { create(:user, email: 'buyer@publicmarket.io') }

    it { is_expected.to be(user.first_name) }

    context 'when first name is empty' do
      before { user.update(first_name: '') }

      it { is_expected.to eq('buyer@') }
    end
  end

  describe 'welcome email' do
    let(:user) { create(:user, confirmed_at: nil) }

    context 'when after create' do
      it 'adds delayed welcome email job' do
        expect {
          user # create user
        }.to change(DelayedWelcomeEmail.jobs, :size).by(1)
      end
    end

    context 'when after confirmation' do
      it 'is sent' do
        expect {
          user.confirm
        }.to have_enqueued_job(ActionMailer::DeliveryJob).with('Spree::UserMailer', 'welcome', 'deliver_now', user.id)
      end

      context 'when after 1 hour' do
        before do
          user # create user
          travel(1.hour + 1.minute)
        end

        it 'is not sent' do
          expect {
            user.confirm
          }.not_to have_enqueued_job(ActionMailer::DeliveryJob).with('Spree::UserMailer', 'welcome', 'deliver_now', user.id)
        end
      end
    end

    context 'with reconfirmation' do
      let(:user) { create(:user, unconfirmed_email: 'newemail@email.com') }

      it 'is not sent' do
        expect {
          user.confirm
        }.not_to change { ActionMailer::Base.deliveries.size }
      end
    end
  end

  describe '#destroy' do
    let!(:user) { create(:user) }

    it 'changes email' do
      user.destroy!
      expect(Spree::User.with_deleted.last.email).to start_with('deleted_')
    end

    it 'skips reconfirmation' do
      expect {
        user.destroy!
      }.not_to change { ActionMailer::Base.deliveries.size }
    end
  end

  describe '#email_change' do
    subject(:change_email) { user.update(email: 'new@super.email') }

    let!(:user) { create(:user) }

    it 'is sent' do
      expect {
        change_email
      }.to have_enqueued_job(ActionMailer::DeliveryJob).with('Spree::UserMailer', 'email_change', 'deliver_now', user.id)
    end
  end
end