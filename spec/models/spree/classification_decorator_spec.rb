RSpec.describe Spree::Classification, type: :model do
  describe '#after_commit_create' do
    subject(:classification) { create(:classification, taxon: uncategorized_taxon) }

    let(:uncategorized_taxon) { create(:taxon, name: Spree::Taxon::UNCATEGORIZED_NAME) }

    describe 'data reconcilation worker' do
      before do
        allow(PublicMarket::Workers::Slack::DataReconcilationWorker).to receive(:perform_async)

        classification
      end

      it 'is called' do
        expect(PublicMarket::Workers::Slack::DataReconcilationWorker).to have_received(:perform_async).with(
          product_id: classification.product_id,
          message_type: 'uncategorized'
        )
      end
    end
  end
end
