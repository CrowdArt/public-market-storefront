RSpec.describe Spree::Orders::VendorView, type: :model do
  let(:order) { create :vendor_order_ready_to_ship, line_items_count: 2 }
  let(:line_item) { order.line_items.first }
  let(:vendor) { line_item.variant.vendor }
  let(:vendor_view) { described_class.new(order, vendor) }

  describe '#line_items' do
    subject(:line_items) { vendor_view.line_items }

    it { expect(order.line_items.count).to eq(2) }
    it { expect(line_items.count).to eq(1) }
    it { expect(line_items.first.variant.vendor).to eq(vendor) }

    context 'when item is canceled' do
      before { line_item.cancel }

      it { expect(line_items.count).to eq(0) }
    end
  end

  describe 'delegation' do
    it { expect(vendor_view.payments).to eq(order.payments) }
    it { expect(vendor_view.state).to eq(order.state) }
    it { expect(vendor_view.checkout_steps).to eq(order.checkout_steps) }
    it { expect(vendor_view.shipment_state).to eq('ready') }
    it { expect(vendor_view.payment_state).to eq(order.payment_state) }
    it { expect(vendor_view.completed?).to eq(order.completed?) }
    it { expect(vendor_view.canceled?).to eq(order.canceled?) }
    it { expect(vendor_view.approved?).to eq(order.approved?) }
    it { expect(vendor_view.billing_address).to eq(order.billing_address) }
  end

  describe '#display_item_total' do
    subject(:total) { vendor_view.display_item_total }

    it { expect(total.to_html).to match(line_item.price.to_s) }

    context 'when item is canceled' do
      before { line_item.cancel }

      it { expect(total.to_html).to match('0') }
    end
  end

  describe '#ship_total' do
    subject(:ship_total) { vendor_view.ship_total }

    it { expect(ship_total).to eq(order.shipments.first.cost) }
    it { expect(vendor_view.display_ship_total.to_html).to be_truthy }
  end

  describe '#tax_total' do
    it { expect(vendor_view.included_tax_total).to be_truthy }
    it { expect(vendor_view.display_included_tax_total.to_html).to be_truthy }
    it { expect(vendor_view.additional_tax_total).to be_truthy }
    it { expect(vendor_view.display_additional_tax_total.to_html).to be_truthy }
  end

  describe '#total' do
    subject(:total) { vendor_view.total }

    it { expect(total).to eq(line_item.price) }
    it { expect(vendor_view.display_total.to_html).to be_truthy }
  end
end
