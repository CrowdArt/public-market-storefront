RSpec.describe Spree::TaxonsController, type: :controller do
  let(:taxon) { create(:user) }

  routes { Spree::Core::Engine.routes }

  describe '#mobile_menu_childs' do
    subject(:get_mobile_menu_childs) { get :mobile_menu_childs }

    before do
      allow(controller).to receive :set_current_order
    end

    it 'skips set_current_order' do
      get_mobile_menu_childs
      expect(controller).not_to have_received(:set_current_order)
    end

    it { is_expected.to be_successful }
  end
end
