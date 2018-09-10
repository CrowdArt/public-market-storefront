RSpec.describe Spree::Payment, type: :model, vcr: true do
  subject(:payment) do
    create(:payment,
           payment_method: create(:stripe_card_payment_method),
           amount: order.total,
           response_code: nil,
           order: order)
  end

  let(:rewards) { order.total * 0.15 }

  context 'when all vendors have accounts' do
    before { payment.order.process_payments! }

    context 'when capture is undone' do
      let(:order) { create :order_with_vendor_items, vendor_accounts: true }

      it { expect(payment.payment_transfers).to be_empty }
      it { expect(payment.reload.state).to eq('pending') }
    end

    context 'when captured' do
      before { payment.reload.capture! }

      context 'with one vendor' do
        subject(:transfer) { payment.payment_transfers.first }

        let(:order) { create :order_with_vendor_items, vendor_accounts: true }

        it 'make charge and transfers' do
          expect(payment.payment_transfers.count).to eq(1)
          expect(payment.reload.state).to eq('completed')
          expect(payment.payment_method_fee).to eq(0.59)

          expect(transfer.response_code).to be_truthy
          expect(transfer.amount).to eq(payment.amount - payment.payment_method_fee - rewards)
          expect(transfer.fee).to eq(payment.payment_method_fee)
          expect(transfer.rewards).to eq(rewards)
        end

        describe 'refund' do
          subject(:refund) { create(:refund, payment: payment.reload, payment_transfer: transfer, amount: amount, transaction_id: nil) }

          context 'when amount is greater than possible' do
            let(:amount) { payment.amount * 2 }

            it 'raises error' do
              expect { refund }.to raise_error(ActiveRecord::RecordInvalid, /Amount is greater/)
            end
          end

          context 'when refund full amount' do
            let(:amount) { transfer.amount }

            it 'refund successfully' do
              expect(refund.transaction_id).to be_truthy
              expect(refund.reversal_id).to be_truthy
            end
          end

          context 'when refund partially' do
            let(:amount) { transfer.amount - 1 }

            it 'refund successfully' do
              expect(refund.transaction_id).to be_truthy
              expect(refund.reversal_id).to be_truthy
              expect(refund.amount).to eq(amount)
              expect(transfer.credit_allowed).to eq(transfer.amount - refund.amount)
            end
          end
        end
      end

      context 'with multiple items from one vendor' do
        let(:vendor) { create(:vendor) }
        let(:order) { create :order_with_vendor_items, line_items_count: 3, vendor_accounts: true, vendor: vendor }

        before { Spree::Variant.update_all(vendor_id: payment.order.vendors.last.id) }

        it 'creates one transfer' do
          expect(payment.payment_transfers.count).to eq(1)
        end
      end

      context 'with multiple vendors' do
        let(:order) { create :order_with_vendor_items, line_item_prices: [70, 30], vendor_accounts: true }

        it 'make charge and transfers' do
          expect(payment.payment_transfers.count).to eq(2)
          expect(payment.payment_transfers.map(&:response_code)).to all(be_truthy)
          expect(payment.amount).to eq(100)
          expect(payment.payment_method_fee).to eq(3.2)
          expect(payment.payment_transfers.map(&:fee)).to match_array([0.96, 2.24])
          expect(payment.payment_transfers.map(&:buyer_amount)).to match_array([70.0, 30.0])
        end

        describe 'refund' do
          subject(:refund) { create(:refund, payment: payment.reload, payment_transfer: transfer, amount: amount, transaction_id: nil) }

          let(:transfer) { payment.payment_transfers.where(response_code: 'tr_1CpMVkI93ruT9p2PdlYehZqb').first }

          context 'when refund partially' do
            let(:amount) { transfer.amount - 1 }

            it 'refund successfully' do
              expect(refund.transaction_id).to be_truthy
              expect(refund.reversal_id).to be_truthy
              expect(refund.amount).to eq(amount)
              expect(transfer.credit_allowed).to eq(transfer.amount - refund.amount)
            end
          end
        end
      end
    end

    context 'when units are cancelled' do
      subject(:transfer) { payment.payment_transfers.first }

      let(:unit) { order.inventory_units.first }

      before { unit.cancel! }

      context 'when one vendor' do
        let(:vendor) { create(:vendor) }
        let(:order) { create :order_with_vendor_items, line_items_count: 2, vendor_accounts: true, vendor: vendor }

        before { payment.reload.capture! }

        it 'do not charge canceled item' do
          expect(order.reload.total).to eq(order.line_items.last.total)
          expect(payment.reload.amount).to eq(order.line_items.last.total)
        end

        it 'make charge and transfers' do
          expect(payment.payment_transfers.count).to eq(1)
          expect(payment.reload.state).to eq('completed')
          expect(payment.payment_method_fee).to eq(0.59)
          expect(transfer.amount).to eq(7.91)
          expect(transfer.fee).to eq(0.59)
          expect(transfer.rewards).to eq(1.5)
        end
      end

      context 'with multiple vendors' do
        let(:order) { create :order_with_vendor_items, line_item_prices: [70, 30], vendor_accounts: true }

        before { payment.reload.capture! }

        it 'do not charge canceled item' do
          expect(order.reload.total).to eq(30)
          expect(payment.reload.amount).to eq(30)
          expect(payment.payment_method_fee).to eq(1.17)
        end

        it 'make charge and transfers' do
          expect(payment.payment_transfers.count).to eq(1)
          expect(payment.reload.state).to eq('completed')
          expect(transfer.amount).to eq(24.33)
          expect(transfer.fee).to eq(payment.payment_method_fee)
          expect(transfer.rewards).to eq(4.5)
        end
      end
    end
  end

  context 'when one vendor does not have an account' do
    let(:order) { create :order_with_vendor_items, vendor_accounts: true }

    before do
      payment.order.vendors.last.update(gateway_account_profile_id: nil)
      payment.order.process_payments!
    end

    it 'make charge and transfers' do
      expect(payment.reload.state).to eq('checkout')
      expect(payment.payment_transfers.map(&:response_code)).to all(be_falsy)
    end
  end
end
