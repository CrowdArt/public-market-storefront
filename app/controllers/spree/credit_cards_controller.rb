module Spree
  class CreditCardsController < Spree::StoreController
    before_action :authenticate_spree_user!
    before_action :load_user

    load_and_authorize_resource class: Spree::CreditCard

    before_action :set_account_tab, only: %i[index edit new]
    before_action :prepare_card_form, only: %i[edit new]

    def index
      @cards = @user.credit_cards
    end

    def new
      @credit_card = Spree::CreditCard.new
      @credit_card.address = @user.addresses&.first&.clone || Spree::Address.build_default
      render :new
    end

    def edit; end

    def create
      @credit_card = @user.credit_cards.build(payment_method_params)
      if @credit_card.save
        redirect_to user_payment_methods_path
      else
        respond_card_with_error
      end
    end

    def update
      if @credit_card.update(card_edit_params)
        flash[:notice] = t('payment_methods.cards.updated')
        redirect_to user_payment_methods_path
      else
        respond_card_with_error
      end
    end

    def destroy
      card = @user.credit_cards.find(params[:id])

      if card.destroy
        flash[:success] = t('payment_methods.cards.deleted')
      else
        flash[:error] = card.errors.full_messages.join(', ')
      end

      redirect_back(fallback_location: 'account/payment')
    end

    private

    def respond_card_with_error
      flash[:error] = @credit_card.errors.full_messages.join(', ')
      respond_to do |format|
        format.html { render :new }
        format.js
      end
    end

    def payment_method_params
      pm_params = params.permit(
        order: { payments_attributes: permitted_payment_attributes },
        payment_source: permitted_source_attributes + [:funding, :use_shipping, address_attributes: permitted_address_attributes]
      )

      payment_method_id = pm_params['order']['payments_attributes'].first['payment_method_id'].to_s
      source_params = pm_params.delete('payment_source')[payment_method_id]

      source_params.merge(payment_method_id: payment_method_id)
    end

    def card_edit_params
      params.require(:credit_card).permit(
        permitted_source_attributes + [:id, :funding, :use_shipping, address_attributes: permitted_address_attributes]
      )
    end

    def load_user
      @user = spree_current_user
    end

    def set_account_tab
      @account_tab = :payment
    end

    def prepare_card_form
      hide_search_bar_on_mobile
      set_back_mobile_link('/account')
      @payment_methods = Spree::PaymentMethod.available
    end
  end
end
