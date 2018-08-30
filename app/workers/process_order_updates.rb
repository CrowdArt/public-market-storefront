require 'sidekiq-scheduler'

class ProcessOrderUpdates
  include Sidekiq::Worker

  def perform(vendor_slug, ftp_key)
    vendor = Spree::Vendor.find_by(slug: vendor_slug)
    puts "Process #{vendor_slug} order updates from #{ftp_key} FTP"
    puts Spree::Orders::Ftp::ProcessOrderUpdatesAction.call(vendor, ftp_key.to_sym) if vendor.present?
  end
end
