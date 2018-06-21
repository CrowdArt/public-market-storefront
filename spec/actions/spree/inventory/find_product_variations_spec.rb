RSpec.describe Spree::Inventory::FindProductVariations, type: :action, search: true do
  subject(:variations) do
    product.class.reindex
    product.class.searchkick_index.refresh
    described_class.call(product)
  end

  let(:name) { FFaker::Book.title }
  let(:author) { FFaker::Book.author }
  let(:taxonomy_name) { 'Books' }
  let(:taxons) { [create(:taxonomy, name: taxonomy_name).root] }
  let(:product) { create :book, name: name, author: author, taxons: taxons, format: 'Trade Cloth' }

  shared_examples 'includes self variation' do
    it { is_expected.to eq [{ name: 'Hardcover', price: product.price.to_f, slug: product.slug, ids: [product.id] }] }
  end

  context 'when no variations' do
    include_examples 'includes self variation'
  end

  describe 'book variations by cover type' do
    context 'when edition is defined' do
      let!(:variation) { create :book, name: name, author: author, taxons: taxons, format: 'Trade Paper', edition: 'Revised' }

      include_examples 'includes self variation'

      context 'when edition is same' do
        let(:product) { create :book, name: name, author: author, taxons: taxons, format: 'Trade Cloth', edition: 'Revised' }

        it do
          is_expected.to include(
            { name: 'Paperback', price: be_positive, slug: variation.slug, ids: [variation.id] },
            { name: 'Hardcover', price: be_positive, slug: product.slug, ids: [product.id] }
          )
        end
      end
    end

    context 'when title and author are the same' do
      let!(:variation) { create :book, name: name, author: author, taxons: taxons, format: 'Trade Paper' }

      it do
        is_expected.to include(
          { name: 'Paperback', price: be_positive, slug: variation.slug, ids: [variation.id] },
          { name: 'Hardcover', price: be_positive, slug: product.slug, ids: [product.id] }
        )
      end
    end

    context 'when author has an mistype' do
      before { create :book, name: name, author: author[0...-1], taxons: taxons, format: 'Trade Paper' }

      include_examples 'includes self variation'
    end

    context 'when only author is the same' do
      before { create :book, author: author, taxons: taxons, format: 'Trade Paper' }

      include_examples 'includes self variation'
    end

    context 'when only title is the same' do
      before { create :book, name: name, taxons: taxons, format: 'Trade Paper' }

      include_examples 'includes self variation'
    end

    context 'when format is the same' do
      let!(:other_book) { create :book, price: 1, name: name, author: author, taxons: taxons, format: 'Trade Cloth' }

      it { expect(variations.size).to eq 1 }
      it { is_expected.to include(name: 'Hardcover', price: product.price.to_f, slug: product.slug, ids: include(product.id, other_book.id)) }
    end

    context 'when taxonomy is not a book' do
      let(:taxons) { [create(:taxonomy, name: 'Electronics').root] }

      before { create :book, name: name, author: author, taxons: taxons, format: 'Trade Paper' }

      it { is_expected.to be_empty }
    end
  end
end
