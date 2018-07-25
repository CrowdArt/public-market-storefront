module Spree
  module Inventory
    module Ftp
      class ProcessInventoryAction < Spree::BaseAction
        param :vendor
        param :ftp_key

        def call
          options = {
            format: 'csv_tab',
            provider: 'bwb',
            product_type: 'books',
            vendor_id: vendor.id
          }

          each_ftp_file do |file|
            Inventory::UploadFileAction.call(options.merge(file_path: file))
          end
        end

        private

        def each_ftp_file
          ftp = PublicMarket::FTP.new(ftp_key, debug: true)
          ftp.nlst.grep(/.txt/).sort.each do |file|
            ftp_file = Tempfile.new(['inventory', SecureRandom.urlsafe_base64].join('-'))
            ftp.get(file, ftp_file)
            yield(ftp_file)
            ftp.delete(file)
          end
        ensure
          ftp.close
        end
      end
    end
  end
end
