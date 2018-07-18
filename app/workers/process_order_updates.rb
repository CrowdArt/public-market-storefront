require 'sidekiq-scheduler'

class ProcessOrderUpdates
  include Sidekiq::Worker

  def perform(vendor_name, ftp_key)
    vendor = Spree::Vendor.find_by(name: vendor_name)
    puts "Process #{vendor_name} order updates from #{ftp_key} FTP"
    puts Spree::Orders::Ftp::ProcessOrderUpdatesAction.call(vendor, ftp_key.to_sym) if vendor.present?
  end
end
