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

  context 'when variations found' do
    let!(:variation) { create(:book, :with_variant, name: name, price: 10, author: author, taxons: taxons, format: 'Trade Paper') }

    it do
      is_expected.to include(
        { name: 'Paperback', variation: 'paperback', price: be_positive, similar_variants: [], slug: variation.slug, id: variation.id },
        { name: 'Hardcover', variation: 'hardcover', price: be_positive, similar_variants: [], slug: product.slug, id: product.id }
      )
    end

    context 'when cheaper variation exists' do
      let!(:cheaper_variation) { create(:book, :with_variant, name: name, price: 0.1, author: author, taxons: taxons, format: 'Trade Paper') }

      it do
        is_expected.to include(
          { name: 'Hardcover', variation: 'hardcover', price: be_positive, similar_variants: [], slug: product.slug, id: product.id },
          {
            name: 'Paperback',
            variation: 'paperback',
            price: be_positive,
            slug: cheaper_variation.slug,
            id: cheaper_variation.id,
            similar_variants: [
              {
                option: variation.variants.first.main_option_name.titleize,
                size: 1,
                price: variation.price.to_f,
                variants: nil
              }
            ]
          }
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
            { name: 'Hardcover', variation: 'hardcover', price: be_positive, similar_variants: [], slug: product.slug, id: product.id },
            {
              name: 'Paperback',
              variation: 'paperback',
              price: be_positive,
              slug: variation.slug,
              id: variation.id,
              similar_variants: [
                {
                  option: cheaper_variation.variants.first.main_option_name.titleize,
                  size: 1,
                  price: cheaper_variation.price.to_f,
                  variants: nil
                }
              ]
            }
          )
        end
      end
    end
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
              option: variant.main_option_name.titleize,
              price: variant.price,
              size: 1,
              variants: nil
            ]
          }
        ]
      )
    end

    context 'when load_variants is set to true' do
      subject(:variations) do
        product.class.reindex
        product.class.searchkick_index.refresh
        described_class.call(product, load_variants: true)
      end

      it 'includes similar variants' do
        expect(variations.size).to eq 1

        is_expected.to include(
          name: 'Hardcover',
          variation: 'hardcover',
          price: product.price.to_f,
          slug: product.slug,
          id: product.id,
          similar_variants: [
            option: variant.main_option_name.titleize,
            price: variant.price,
            size: 1,
            variants: [variant]
          ]
        )
      end
    end
  end
end
