RSpec.describe Spree::Inventory::Searchers::FindSimilarProducts, type: :action, search: true do
  subject(:variations) do
    product.class.reindex
    product.class.searchkick_index.refresh
    described_class.call(product)
  end

  let(:name) { FFaker::Book.title }
  let(:author) { FFaker::Book.author }
  let(:taxonomy_name) { 'Books' }
  let(:taxons) { [create(:taxonomy, name: taxonomy_name).root] }
  let(:product) do
    create(:book, :with_variant, name: name, author: author, taxons: taxons, format: 'Trade Cloth')
  end

  shared_examples 'includes only product' do
    it do
      expect(variations.size).to eq 1
      is_expected.to include(hash_including('_id': product.id.to_s))
    end
  end

  context 'when no variations' do
    include_examples 'includes only product'
  end

  describe 'similar book products' do
    context 'when title and author are the same' do
      let!(:variation) { create(:book, :with_variant, name: name, price: 10, author: author, taxons: taxons, format: 'Trade Paper') }

      it do
        is_expected.to include(
          hash_including('_id': variation.id.to_s),
          hash_including('_id': product.id.to_s)
        )
      end

      describe 'filters by variation' do
        subject(:variations) do
          product.class.reindex
          product.class.searchkick_index.refresh
          described_class.call(product, filter_by_variation: product.search_variation)
        end

        include_examples 'includes only product'
      end
    end

    context 'when author has an mistype' do
      before { create(:book, :with_variant, name: name, author: author[0...-1], taxons: taxons, format: 'Trade Paper') }

      include_examples 'includes only product'
    end

    context 'when only author is the same' do
      before { create(:book, :with_variant, name: 'Other book name super exclusive', author: author, taxons: taxons, format: 'Trade Paper') }

      include_examples 'includes only product'
    end

    context 'when only title is the same' do
      before { create(:book, :with_variant, name: name, taxons: taxons, format: 'Trade Paper') }

      include_examples 'includes only product'
    end

    context 'when format is the same' do
      before { create(:book, price: 1, name: name, author: author, taxons: taxons, format: 'Trade Cloth') }

      include_examples 'includes only product'
    end

    context 'when variation taxonomy is not a book' do
      let(:other_taxons) { [create(:taxonomy, name: 'Electronics').root] }

      before { create(:book, :with_variant, name: name, price: 10, author: author, taxons: other_taxons, format: 'Trade Paper') }

      include_examples 'includes only product'
    end
  end
end
