RSpec.describe Spree::Vendor, type: :model do
  describe '#shipping_methods' do
    subject { create(:vendor).shipping_methods.any? }

    it { is_expected.to be true }
  end
end
