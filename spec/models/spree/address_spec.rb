RSpec.describe Spree::Address, type: :model do
  describe 'phone number' do
    subject { build_stubbed(:address, phone: phone) }

    context 'with blank number' do
      let(:phone) { '' }

      it { is_expected.to be_valid }
    end

    context 'with valid number' do
      let(:phone) { '+1 999 710 88 99' }

      it { is_expected.to be_valid }
    end

    context 'with invalid number' do
      let(:phone) { '+1 71 88 99' }

      it { is_expected.not_to be_valid }
    end

    describe 'normalisation' do
      subject do
        address = create(:address, phone: phone)
        address.phone
      end

      let(:phone) { '9997108899' }

      it { is_expected.to eq('+19997108899') }
    end
  end
end
