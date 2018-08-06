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

          each_ftp_file do |original_name, file|
            Inventory::UploadFileAction.call(options.merge(file_path: file, original_name: original_name))
          end
        end

        private

        def each_ftp_file
          ftp = PublicMarket::FTP.new(ftp_key, debug: true)
          ftp.nlst.grep(/.txt/).sort.each do |file|
            tmp_file = Tempfile.new(['inventory', SecureRandom.urlsafe_base64].join('-'))
            ftp.get(file, tmp_file)
            yield(file, tmp_file)
            ftp.delete(file)
          end
        ensure
          ftp.close
        end
      end
    end
  end
end
