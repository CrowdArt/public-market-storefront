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
  let(:product) do
    create(:book, :with_variant, name: name, author: author, taxons: taxons, format: 'Trade Cloth')
  end

  shared_examples 'includes self variation' do
    it do
      is_expected.to eq(
        [
          { name: 'Hardcover', variation: 'hardcover', similar_variants: [], price: product.price.to_f, slug: product.slug, id: product.id }
        ]
      )
    end
  end

  context 'when no variations' do
    include_examples 'includes self variation'
  end

  describe 'book variations by cover type' do
    context 'when title and author are the same' do
      let!(:variation) { create(:book, :with_variant, name: name, author: author, taxons: taxons, format: 'Trade Paper') }

      it do
        is_expected.to include(
          { name: 'Paperback', variation: 'paperback', price: be_positive, similar_variants: [], slug: variation.slug, id: variation.id },
          { name: 'Hardcover', variation: 'hardcover', price: be_positive, similar_variants: [], slug: product.slug, id: product.id }
        )
      end

      context 'when previous variation provided' do
        subject(:variations) do
          product.class.reindex
          product.class.searchkick_index.refresh
          described_class.call(product, variation)
        end

        it do
          is_expected.to include(
            { name: 'Paperback', variation: 'paperback', price: be_positive, similar_variants: [], slug: variation.slug, id: variation.id },
            { name: 'Hardcover', variation: 'hardcover', price: be_positive, similar_variants: [], slug: product.slug, id: product.id }
          )
        end
      end
    end

    context 'when author has an mistype' do
      let!(:variation) { create(:book, :with_variant, name: name, author: author[0...-1], taxons: taxons, format: 'Trade Paper') }

      it do
        is_expected.to include(
          { name: 'Paperback', variation: 'paperback', price: be_positive, similar_variants: [], slug: variation.slug, id: variation.id },
          { name: 'Hardcover', variation: 'hardcover', price: be_positive, similar_variants: [], slug: product.slug, id: product.id }
        )
      end
    end

    context 'when only author is the same' do
      before { create(:book, :with_variant, name: 'Other book name super exclusive', author: author, taxons: taxons, format: 'Trade Paper') }

      include_examples 'includes self variation'
    end

    context 'when only title is the same' do
      before { create(:book, :with_variant, name: name, taxons: taxons, format: 'Trade Paper') }

      include_examples 'includes self variation'
    end

    context 'when format is the same' do
      before { create(:book, price: 1, name: name, author: author, taxons: taxons, format: 'Trade Cloth') }

      include_examples 'includes self variation'
    end

    context 'when taxonomy is not a book' do
      let(:taxons) { [create(:taxonomy, name: 'Electronics').root] }

      before { create(:book, :with_variant, name: name, author: author, taxons: taxons, format: 'Trade Paper') }

      it { is_expected.to be_empty }
    end

    describe 'similar variants' do
      let(:book_with_variant) { create(:book, price: 1, name: name, author: author, taxons: taxons, format: 'Trade Cloth') }
      let!(:variant) { create(:variant, product: book_with_variant, price: 1) }

      it 'includes similar variants' do
        is_expected.to eq(
          [
            {
              name: 'Hardcover',
              variation: 'hardcover',
              price: product.price.to_f,
              slug: product.slug,
              id: product.id,
              similar_variants: [
                option: variant.main_option_value,
                price: variant.price,
                size: 1,
                variants: [variant]
              ]
            }
          ]
        )
      end
    end
  end
end
