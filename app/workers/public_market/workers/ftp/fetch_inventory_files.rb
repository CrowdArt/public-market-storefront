require 'sidekiq-scheduler'

module PublicMarket
  module Workers
    module FTP
      class FetchInventoryFiles
        include Sidekiq::Worker

        def perform(vendor_slug, ftp_key)
          vendor = Spree::Vendor.find_by(slug: vendor_slug)
          puts "Process #{vendor_slug} inventory files from #{ftp_key} FTP"
          puts Spree::Inventory::Ftp::ProcessInventoryAction.call(vendor, ftp_key.to_sym) if vendor.present?
        end
      end
    end
  end
end
