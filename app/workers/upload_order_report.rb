require 'sidekiq-scheduler'

class UploadOrderReport
  include Sidekiq::Worker

  def perform(vendor_slug, ftp_key)
    vendor = Spree::Vendor.find_by(slug: vendor_slug)
    puts "Upload #{vendor_slug} order report to #{ftp_key} FTP"
    puts Spree::Orders::Ftp::UploadOrderReportAction.call(vendor, ftp_key.to_sym) if vendor.present?
  end
end
