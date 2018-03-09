module Spree
  class CreditCardsController < Spree::StoreController
    before_action :authenticate_spree_user!
    before_action :load_user

    def new
      @payment_methods = Spree::PaymentMethod.available
      render :new
    end

    def create
      return redirect_to '/account/payment' if @user.update(payment_method_params)
      new
    end

    def destroy
      card = @user.credit_cards.find(params[:id])

      if card.destroy
        flash[:success] = t('payment_methods.cards.deleted')
      else
        flash[:error] = card.errors.full_messages.join(', ')
      end

      redirect_back(fallback_location: 'account')
    end

    private

    def payment_method_params
      pm_params = params.permit(
        order: { payments_attributes: permitted_payment_attributes },
        payment_source: permitted_source_attributes
      )

      payment_method_id = pm_params['order']['payments_attributes'].first['payment_method_id'].to_s
      source_params = pm_params.delete('payment_source')[payment_method_id]

      { credit_cards_attributes: [source_params.merge(payment_method_id: payment_method_id)] }
    end

    def load_user
      @user = spree_current_user
    end
  end
end
