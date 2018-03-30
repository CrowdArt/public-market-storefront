RSpec.describe 'taxon dropdown', type: :feature, js: true do
  subject { page }

  let!(:taxon) { create(:taxon) }

  describe 'shows default first category' do
    before { visit '/' }

    it { is_expected.to have_text(taxon.name) }

    describe 'on search' do
      before do
        find('.btn-search').click
      end

      it { is_expected.to have_text(taxon.name) }
    end
  end

  describe 'select all products' do
    before do
      visit '/'
      find('#taxon-menu').click
      find('a', text: 'All Products').click
      find('.btn-search').click
    end

    it { is_expected.to have_text('All Products') }

    it 'has checked class' do
      expect(page).to have_css("li a.checked[data-taxon-name='All Products']", visible: false)
    end
  end
end
