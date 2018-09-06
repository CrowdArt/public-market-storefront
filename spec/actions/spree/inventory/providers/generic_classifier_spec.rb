RSpec.describe Spree::Inventory::Providers::GenericClassifier, type: :action do
  subject(:taxons) do
    described_class.call(product, taxon_candidates)
    product.taxons
  end

  let(:product) { create(:product) }
  let(:taxon_candidates) { [] }

  context 'with empty candidates' do
    it 'categorises product as other' do
      expect(taxons.first.pretty_name).to eq('Other -> Uncategorized')
    end
  end

  context 'with existing candidates' do
    let(:taxon_candidates) { ['HealthPersonalCare'] }
    let!(:taxonomy) { create(:taxonomy, name: 'Beauty & Health') }

    context 'with existing mapping' do
      context 'with not existing taxon' do
        it 'categorises product as uncategorized' do
          expect(taxons.count).to eq(1)
          expect(taxons.first.pretty_name).to eq('Beauty & Health -> Uncategorized')
        end
      end

      context 'with existing taxon' do
        before do
          create(:taxon, taxonomy: taxonomy, name: 'Health & Personal Care')
        end

        it 'categorises product' do
          expect(taxons.count).to eq(1)
          expect(taxons.first.pretty_name).to eq('Beauty & Health -> Health & Personal Care')
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
