RSpec.describe Spree::LineItem, type: :model do
  describe 'hash_id' do
    let(:line_item) { create(:line_item) }

    it { expect(line_item.hash_id.to_i).to be > 0 }
    it { expect(described_class.decoded_id(line_item.hash_id)).to eq(line_item.id) }
    it { expect(described_class.find_by_hash_id(line_item.hash_id)).to eq(line_item) } # rubocop:disable Rails/DynamicFindBy
  end
end
