RSpec.describe Spree::Inventory::Providers::Generic::Classifier, type: :action do
  subject(:taxons) do
    described_class.call(product, taxon_candidates, taxonomy_name: taxonomy_name)
    product.taxons
  end

  let(:product) { create(:product) }
  let(:taxon_candidates) { [] }
  let(:taxonomy_name) { taxon_candidates.first }

  context 'with empty candidates' do
    it 'categorises product as other' do
      expect(taxons.first.pretty_name).to eq('Other -> Uncategorized')
    end
  end

  context 'with existing candidates' do
    let(:taxon_candidates) { ['HealthPersonalCare'] }

    context 'with existing mapping' do
      it 'categorises product' do
        expect(taxons.count).to eq(1)
        expect(taxons.first.pretty_name).to eq('Beauty & Health -> Health & Personal Care')
      end

      context 'when existing classifier' do
        let(:taxon_candidates) { [['Books / Detective']] }
        let(:taxonomy_name) { 'Books' }

        it 'categorises product as uncategorized' do
          expect(taxons.count).to eq(1)
          expect(taxons.first.pretty_name).to eq('Books -> Uncategorized')
        end
      end
    end

    context 'with not existing mapping' do
      let(:taxon_candidates) { ['CareCarePersonal'] }

      it 'categorises product' do
        expect(taxons.first.pretty_name).to eq('Other -> Uncategorized')
      end
    end
  end
end
