RSpec.describe Spree::BaseHelper, type: :helper do
  include Spree::BaseHelper

  let(:current_store) { build_stubbed(:store) }
  let(:title) { current_store.name }

  describe '#meta_data_tags' do
    describe 'description' do
      let(:controller_name) { 'product' }

      context 'when product' do
        before do
          @product = build_stubbed(:product, description: '<div>Hey hey</div>', meta_description: '<div>Hey hey</div>')
        end

        it 'strips html tags' do
          expect(meta_data_tags).not_to include('&lt;', '&gt;')
        end
      end
    end
  end
end
