RSpec.describe Spree::User, type: :model do
  describe 'validates names' do
    subject do
      build_stubbed(:user, first_name: first_name)
    end

    let(:first_name) { 'validname' }

    it { is_expected.to be_valid }

    context 'when is too long' do
      let(:first_name) { 'Sklodovsckaya-Curie Sklodovsckaya-Curie' }

      it { is_expected.not_to be_valid }
    end

    context 'with space in name' do
      let(:first_name) { 'valid name' }

      it { is_expected.to be_valid }
    end

    context 'with quote in name' do
      let(:first_name) { "valid' name" }

      it { is_expected.to be_valid }

      context 'when double ' do
        let(:first_name) { 'Sklodovsckaya" Curie' }

        it { is_expected.not_to be_valid }
      end
    end

    context 'with dash in name' do
      let(:first_name) { 'Sklodovsckaya-Curie' }

      it { is_expected.to be_valid }

      context 'when multiple in row' do
        let(:first_name) { 'Sklodovsckaya---Curie' }

        it { is_expected.not_to be_valid }
      end
    end

    context 'with unicode letters in name' do
      let(:first_name) { 'Argüello' }

      it { is_expected.to be_valid }
    end

    context 'with numbers in name' do
      let(:first_name) { 'Richard 5th' }

      it { is_expected.to be_valid }
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

  describe 'validates login' do
    subject do
      build_stubbed(:user, login: login)
    end

    let(:login) { 'validname' }

    it { is_expected.to be_valid }

    context 'when too short' do
      let(:login) { 'val' }

      it { is_expected.not_to be_valid }
    end

    context 'when too long' do
      let(:login) { 'valvalvalvalvalvalvalvalvalvalvalvalval' }

      it { is_expected.not_to be_valid }
    end

    context 'with space' do
      let(:login) { 'valid name' }

      it { is_expected.not_to be_valid }
    end

    context 'with unicode letters' do
      let(:login) { 'üsername' }

      it { is_expected.not_to be_valid }
    end

    context 'with digits' do
      let(:login) { 'user1' }

      it { is_expected.to be_valid }

      context 'when in first place' do
        let(:login) { '1user' }

        it { is_expected.not_to be_valid }
      end
    end

    context 'with dashes' do
      let(:login) { 'valid-user' }

      it { is_expected.to be_valid }

      context 'when multiple in row' do
        let(:login) { 'valid--user' }

        it { is_expected.not_to be_valid }
      end
    end

    context 'with chars' do
      let(:login) { 'valid-use__r' }

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

  describe '#display_name' do
    subject { user.display_name }

    let(:user) { create(:user, email: 'buyer@publicmarket.io') }

    it { is_expected.to eq(user.first_name) }

    context 'when first name is empty' do
      before { user.update_columns(first_name: nil) }

      it { is_expected.to eq('buyer') }

      context 'when login is present' do
        before { user.update_columns(login: 'mysuperlogin') }

        it { is_expected.to eq('mysuperlogin') }
      end
    end
  end

  describe '#name_initials' do
    subject { user.name_initials }

    let(:user) { create(:user, login: 'superbuyer') }

    it { is_expected.to eq(user.first_name.first + user.last_name.first) }

    context 'when first name is empty' do
      before { user.update_columns(first_name: nil) }

      it { is_expected.to eq(user.login.first) }

      context 'when login is empty' do
        before { user.update_columns(login: nil) }

        it { is_expected.to eq(user.email.first) }
      end
    end
  end

  describe 'welcome email', enqueue: true do
    let!(:user) { create(:user, confirmed_at: nil) }

    it { expect(ActionMailer::DeliveryJob).to have_been_enqueued.with('Spree::UserMailer', 'welcome', 'deliver_now', user.id) }
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

    context 'when user has orders' do
      let!(:order) { create(:vendor_order_ready_to_ship, user: user) }

      before { user.destroy! }

      it { expect(user).to be_deleted }
      it { expect(order.user).to be_nil }
    end
  end

  describe '#email_change', enqueue: true do
    subject(:change_email) { user.update(email: 'new@super.email') }

    let(:old_email) { 'user@old.email' }
    let!(:user) { create(:user, email: old_email) }

    it 'is sent' do
      expect {
        change_email
      }.to have_enqueued_job(ActionMailer::DeliveryJob).with('Spree::UserMailer', 'email_change', 'deliver_now', user.id, old_email)
    end
  end
end
