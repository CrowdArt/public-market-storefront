require 'sidekiq-scheduler'

class UploadOrderReport
  include Sidekiq::Worker

  def perform(vendor_name, ftp_key)
    vendor = Spree::Vendor.find_by(name: vendor_name)
    puts "Upload #{vendor_name} order report to #{ftp_key} FTP"
    puts Spree::Orders::Ftp::UploadOrderReportAction.call(vendor, ftp_key) if vendor.present?
  end
end
