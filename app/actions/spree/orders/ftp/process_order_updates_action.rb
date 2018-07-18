module Spree
  module Orders
    module Ftp
      class ProcessOrderUpdatesAction < Spree::BaseAction
        param :vendor
        param :ftp_key

        def call
          each_ftp_update_file do |file|
            CSV.foreach(file, col_sep: "\t", headers: true) do |row|
              process_update(row)
            end
          end
        end

        private

        def each_ftp_update_file
          ftp = PublicMarket::FTP.new(ftp_key, debug: true)
          ftp.nlst('Confirm').each do |file|
            filename = "Confirm/#{file}"
            ftp_file = Tempfile.new('updates')
            ftp.get(filename, ftp_file)
            yield(ftp_file)
            ftp.delete(filename)
          end
        ensure
          ftp.close
        end

        def process_update(row)
          Spree::Orders::UpdateLineItemAction.new(
            item_number: row['ABEPOITEMID'],
            order_id: row['ABEPOID'],
            action: row['STATUS'].downcase,
            shipped_at: (Time.zone.parse(row['DATESHIPPED']).to_i if row['DATESHIPPED'].present?),
            tracking_number: row['TRACKINGNUMBER']
          ).call
        end
      end
    end
  end
end
