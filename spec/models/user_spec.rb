require 'rails_helper'

RSpec.describe Spree::User, type: :model do
  describe 'validates names' do
    subject do
      build_stubbed(:bookstore_user, first_name: first_name)
    end

    let(:first_name) { 'valid name' }

    it { is_expected.to be_valid }

    context 'with numbers in name' do
      let(:first_name) { 'Richard 5th' }

      it { is_expected.to be_valid }
    end

    context 'with dash in name' do
      let(:first_name) { 'Sklodovskaya-Curie' }

      it { is_expected.to be_valid }
    end

    context 'with unicode letters in name' do
      let(:first_name) { 'Argüello' }

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
end
