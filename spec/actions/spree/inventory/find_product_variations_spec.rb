RSpec.describe Spree::Inventory::FindProductVariations, type: :action, search: true do
  subject(:variations) do
    product.class.reindex
    described_class.call(product)
  end

  let(:name) { FFaker::Book.title }
  let(:author) { FFaker::Book.author }
  let(:taxonomy_name) { 'Books' }
  let(:taxons) { [create(:taxonomy, name: taxonomy_name).root] }
  let(:product) { create :book, name: name, author: author, taxons: taxons, format: 'Trade Cloth' }

  context 'when no variations' do
    it { is_expected.to be_empty }
  end

  describe 'book variations by cover type' do
    context 'when title and author are the same' do
      before { create :book, name: name, author: author, taxons: taxons, format: 'Trade Paper' }

      it do
        is_expected.to include(
          { name: 'Paperback', price: be_positive, slug: be },
          name: 'Hardcover', price: be_positive, slug: be
        )
      end
    end

    context 'when author has an mistype' do
      before { create :book, name: name, author: author[0...-1], taxons: taxons, format: 'Trade Paper' }

      it { is_expected.to be_empty }
    end

    context 'when only author is the same' do
      before { create :book, author: author, taxons: taxons, format: 'Trade Paper' }

      it { is_expected.to be_empty }
    end

    context 'when only title is the same' do
      before { create :book, name: name, taxons: taxons, format: 'Trade Paper' }

      it { is_expected.to be_empty }
    end

    context 'when format is the same' do
      before { create :book, name: name, author: author, taxons: taxons, format: 'Trade Cloth' }

      it { is_expected.to be_empty }
    end

    context 'when taxonomy is not a book' do
      let(:taxons) { [create(:taxonomy, name: 'Electronics').root] }

      before { create :book, name: name, author: author, taxons: taxons, format: 'Trade Paper' }

      it { is_expected.to be_empty }
    end
  end
end
