RSpec.describe ApiDocsController, type: :controller do
  describe '#index' do
    subject { get :index }

    it { is_expected.to be_successful }
  end

  describe '#schema' do
    subject(:get_schema) { get :schema }

    it { is_expected.to be_successful }

    it 'returns swagger json' do
      expect(get_schema.parsed_body).to include('swagger')
      expect(get_schema.parsed_body).to include('Public Market API specification')
    end
  end
end
