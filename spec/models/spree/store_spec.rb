RSpec.describe Spree::Store, type: :model do
  describe '#meta_description' do
    subject do
      build_stubbed(:store, meta_description: meta_description).meta_description
    end

    context 'when empty' do
      let(:meta_description) { '' }

      it { is_expected.to eq Spree.t(:default_meta_description, default: nil) }
    end

    context 'when not empty' do
      let(:meta_description) { 'Meta description' }

      it { is_expected.to eq meta_description }
    end
  end
end
