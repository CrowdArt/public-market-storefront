RSpec.describe PublicMarket::FTP, vcr: true do
  let(:ftp) { described_class.new(:test_ftp, debug: true) }

  # it { expect(ftp.nlst).to eq('OK') }
end