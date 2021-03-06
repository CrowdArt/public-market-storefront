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
    let!(:variation) { create(:book, :with_variant, name: name, price: 10, author: author, taxons: taxons, format: 'Paperback') }

    it do
      is_expected.to include(
        {
          variation_name_presentation: 'Paperback',
          variation_name: 'paperback',
          price: be_positive,
          similar_variants: [],
          slug: variation.slug,
          id: variation.id
        },
        {
          variation_name_presentation: 'Hardcover',
          variation_name: 'hardcover',
          price: be_positive,
          similar_variants: [],
          slug: product.slug,
          id: product.id
        }
      )
    end

    context 'when cheaper variation exists' do
      let!(:cheaper_variation) { create(:book, :with_variant, name: name, price: 0.1, author: author, taxons: taxons, format: 'Paperback') }

      it do
        is_expected.to include(
          {
            variation_name_presentation: 'Hardcover',
            variation_name: 'hardcover',
            price: be_positive,
            similar_variants: [],
            slug: product.slug,
            id: product.id
          },
          {
            variation_name_presentation: 'Paperback',
            variation_name: 'paperback',
            price: be_positive,
            slug: cheaper_variation.slug,
            id: cheaper_variation.id,
            similar_variants: include(
              {
                option_value: cheaper_variation.variants.first.main_option_name.titleize,
                size: 1,
                price: cheaper_variation.variants.first.price
              },
              {
                option_value: variation.variants.first.main_option_name.titleize,
                size: 1,
                price: variation.price.to_f
              }
            )
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
            {
              variation_name_presentation: 'Hardcover',
              variation_name: 'hardcover',
              price: be_positive,
              similar_variants: [],
              slug: product.slug,
              id: product.id
            },
            {
              variation_name_presentation: 'Paperback',
              variation_name: 'paperback',
              price: be_positive,
              slug: variation.slug,
              id: variation.id,
              similar_variants: include(
                {
                  option_value: cheaper_variation.variants.first.main_option_name.titleize,
                  size: 1,
                  price: cheaper_variation.price.to_f
                },
                {
                  option_value: variation.variants.first.main_option_name.titleize,
                  price: variation.variants.first.price,
                  size: 1
                }
              )
            }
          )
        end
      end
    end
  end

  describe 'similar variants' do
    let(:book_with_variant) { create(:book, price: 1, name: name, author: author, taxons: taxons, format: 'Trade Cloth') }
    let!(:variant) { create(:variant, product: book_with_variant, price: 1) }

    it 'includes similar variants and current product variant' do
      is_expected.to eq(
        [
          {
            variation_name_presentation: 'Hardcover',
            variation_name: 'hardcover',
            price: product.price.to_f,
            slug: product.slug,
            id: product.id,
            similar_variants: [
              {
                option_value: variant.main_option_name.titleize,
                price: variant.price,
                size: 1
              },
              {
                option_value: product.variants.first.main_option_name.titleize,
                price: product.variants.first.price,
                size: 1
              }
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
          variation_name_presentation: 'Hardcover',
          variation_name: 'hardcover',
          price: product.price.to_f,
          slug: product.slug,
          id: product.id,
          similar_variants: include(variant, product.variants.first)
        )
      end
    end
  end
end
