RSpec.describe PublicMarket::FTP, skip: true do
  let(:ftp) { described_class.new(:test_ftp, debug: false) }
  let(:file) { File.join(Dir.pwd, 'spec/fixtures/files', 'book_upload.csv') }

  it { expect(ftp.nlst('Confirm')).to eq([]) }
  it { expect(ftp.status).to match('211') }
  it { expect(ftp.close).to be_nil }

  it 'uploads/downloads/deletes files' do
    ftp.mkdir('test')
    ftp.put(file, 'test/book_upload.csv')
    ftp.get('test/book_upload.csv', Tempfile.new)
    ftp.delete('test/book_upload.csv')
    expect(ftp.nlst('test')).to eq([])
    ftp.rmdir('test')
    expect(ftp.nlst).to eq([])
  end
end
