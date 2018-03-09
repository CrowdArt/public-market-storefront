require 'rails_helper'

RSpec.describe Spree::User, type: :model do
  describe 'validates names' do
    subject do
      build_stubbed(:bookstore_user, first_name: first_name)
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
      build_stubbed(:bookstore_user, password: password)
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

  describe 'send welcome email' do
    let!(:user) { create(:bookstore_user) }

    it { expect(ActionMailer::DeliveryJob).to have_been_enqueued.with('Spree::UserMailer', 'welcome', 'deliver_now', user.id) }
  end

  describe 'set first & last name from shipping address' do
    let!(:user) { create(:bookstore_user, first_name: nil, last_name: nil) }

    before { user.update(ship_address: create(:address)) }

    it { expect(user.first_name).not_to be_nil }
  end
end
