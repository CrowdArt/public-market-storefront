require 'spec_helper'

RSpec.describe Spree::Orders::FetchVendorOrdersAction, type: :action do
  subject(:orders) { described_class.new(vendor, from).call }

  let(:order) { create(:completed_vendor_order, line_items_count: 2) }
  let(:line_item) { order.line_items.first }
  let(:other_line_item) { order.line_items.second }
  let(:vendor) { line_item.variant.vendor }
  let(:from) { nil }

  it { expect(orders.first.order).to eq(order) }
end
