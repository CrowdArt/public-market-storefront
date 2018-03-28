module Spree
  class CreditCardsController < Spree::StoreController
    before_action :authenticate_spree_user!
    before_action :load_user
    before_action :hide_search_bar_on_mobile, only: :new

    def new
      set_back_mobile_link('/account')
      @payment_methods = Spree::PaymentMethod.available
      @credit_card = Spree::CreditCard.new
      @credit_card.address ||= @user.shipping_address&.clone || Spree::Address.build_default
      render :new
    end

    def create
      @credit_card = @user.credit_cards.build(payment_method_params)
      if @credit_card.save
        redirect_to '/account/payment'
      else
        flash[:error] = @credit_card.errors.full_messages.join(', ')
        respond_to do |format|
          format.html { render :new }
          format.js
        end
      end
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
        payment_source: permitted_source_attributes + [:funding, :use_shipping, address_attributes: permitted_address_attributes]
      )

      payment_method_id = pm_params['order']['payments_attributes'].first['payment_method_id'].to_s
      source_params = pm_params.delete('payment_source')[payment_method_id]

      source_params.merge(payment_method_id: payment_method_id)
    end

    def load_user
      @user = spree_current_user
    end
  end
end
