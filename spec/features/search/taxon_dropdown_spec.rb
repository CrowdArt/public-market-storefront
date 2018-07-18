RSpec.describe 'taxon dropdown', type: :feature, js: true do
  subject { page }

  let!(:taxon) { create(:taxonomy) }

  describe 'shows All Products by default' do
    before { visit '/' }

    it { is_expected.to have_css('#taxon-menu', text: 'All Products') }
  end

  describe 'selects taxon' do
    before do
      visit '/'
      find('#taxon-menu').click
      find('#taxon-dropdown a', text: taxon.name).click
      find('.btn-search').click
    end

    it { is_expected.to have_css('#taxon-menu', text: taxon.name) }

    it 'has checked class' do
      expect(page).to have_css("li a.checked[data-taxon-name='#{taxon.name}']", visible: false)
    end
  end
end
