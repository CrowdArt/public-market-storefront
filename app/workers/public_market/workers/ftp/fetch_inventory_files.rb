require 'sidekiq-scheduler'

module PublicMarket
  module Workers
    module FTP
      class FetchInventoryFiles
        include Sidekiq::Worker

        def perform(vendor_name, ftp_key)
          vendor = Spree::Vendor.find_by(name: vendor_name)
          puts "Process #{vendor_name} inventory files from #{ftp_key} FTP"
          puts Spree::Inventory::Ftp::ProcessInventoryAction.call(vendor, ftp_key.to_sym) if vendor.present?
        end
      end
    end
  end
end
