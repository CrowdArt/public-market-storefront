RSpec.describe Spree::User, type: :model do
  describe 'validates names' do
    subject do
      build_stubbed(:pm_user, first_name: first_name)
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
      build_stubbed(:pm_user, password: password)
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
    let!(:user) { create(:pm_user, first_name: nil, last_name: nil) }

    before { user.update(ship_address: create(:address)) }

    it { expect(user.first_name).not_to be_nil }
  end

  describe 'username' do
    subject { user.username }

    let(:user) { create(:pm_user, email: 'buyer@publicmarket.io') }

    it { is_expected.to be(user.first_name) }

    context 'when first name is empty' do
      before { user.update(first_name: '') }

      it { is_expected.to eq('buyer@') }
    end
  end

  describe 'welcome email' do
    let(:user) { create(:pm_user, confirmed_at: nil) }

    before do
      stub_current_store
    end

    it 'is sent after confirmation' do
      expect {
        user.confirm
      }.to have_enqueued_job(ActionMailer::DeliveryJob).with('Spree::UserMailer', 'welcome', 'deliver_now', user.id)
    end

    context 'with reconfirmation' do
      let(:user) { create(:pm_user, unconfirmed_email: 'newemail@email.com') }

      it 'is not sent' do
        expect {
          user.confirm
        }.not_to have_enqueued_job(ActionMailer::DeliveryJob)
      end
    end
  end
end
