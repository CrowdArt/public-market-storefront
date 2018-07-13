require 'spec_helper'

RSpec.describe Spree::Orders::Ftp::UploadOrderReportAction, type: :action do
  subject(:result) { File.open(action.call).read }

  let(:action) { described_class.new(vendor, :test_ftp, skip_ftp_upload: true) }
  let(:order) { create(:vendor_order_ready_to_ship, line_items_count: 2) }
  let(:line_item) { order.line_items.first }
  let(:vendor) { line_item.variant.vendor }

  it { expect(result).to match(line_item.variant.sku) }
  it { expect(result).to match("\t") }
end
