RSpec.describe Spree::SimilarVariantsHelper, type: :helper do
  # include Spree::BaseHelper

  describe '#available_filter_options' do
    subject(:filters) { available_filter_options(variants) }

    let(:product) { build_stubbed(:book) }

    let(:variant_1) { build_stubbed(:book_variant) }
    let(:variant_2) { build_stubbed(:book_variant) }
    let(:variants) { [variant_1, variant_2] }

    context 'when multiple different options' do
      it 'shows options to filter' do
        expect(filters).to eq(
          variant_1.mapped_main_option_value => [variant_1.main_option_value],
          variant_2.mapped_main_option_value => [variant_2.main_option_value]
        )
      end
    end

    context 'when one parent option' do
      let(:variant_1) { build(:book_variant, option_values: build_stubbed_list(:option_value, 1, name: 'New', presentation: 'New')) }
      let(:variants) { [variant_1] }

      it { is_expected.to be_nil }
    end

    context 'when one parent and one child option' do
      let(:variant_1) do
        build_stubbed(:book_variant, option_values: build_stubbed_list(:option_value, 1, name: 'Like New', presentation: 'Like New'))
      end

      let(:variant_2) do
        build_stubbed(:book_variant, option_values: build_stubbed_list(:option_value, 1, name: 'Like New', presentation: 'Like New'))
      end

      it { is_expected.to be_nil }
    end
  end
end
