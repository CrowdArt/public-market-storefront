require 'spec_helper'

RSpec.describe Spree::Payments::CapturePaymentsAction, type: :action, vcr: true do
  subject(:call) { described_class.new.call }

  subject(:payment) do
    create(:payment,
           payment_method: create(:stripe_card_payment_method),
           amount: order.total,
           response_code: nil,
           order: order)
  end

  let(:order) { create(:completed_vendor_order, line_items_count: 2, vendor_accounts: true) }
  let(:line_item) { order.line_items.first }
  let(:vendor) { line_item.variant.vendor }

  before { payment.order.process_payments! }

  context 'when less than 5 days past' do
    context 'when all items are ordered' do
      it { expect { call }.not_to change { payment.reload.state }.from('pending') }
    end

    context 'when all units are confirmed' do
      before { order.inventory_units.each(&:ship!) }

      it { expect { call }.to change { payment.reload.state }.from('pending').to('completed') }
    end
  end

  context 'when 5 days past' do
    before { payment.update(created_at: 6.days.ago) }

    context 'when all units are on hand' do
      it { expect { call }.to change { payment.reload.state }.from('pending').to('void') }
      it { expect { call }.to change { payment.order.reload.state }.from('complete').to('canceled') }
    end

    context 'when some units are shiped' do
      before { order.inventory_units.first.ship! }

      it { expect { call }.to change { payment.reload.state }.from('pending').to('completed') }
    end

    context 'when all units are confirmed' do
      before { order.inventory_units.each(&:ship!) }

      it { expect { call }.to change { payment.reload.state }.from('pending').to('completed') }
    end
  end
end
