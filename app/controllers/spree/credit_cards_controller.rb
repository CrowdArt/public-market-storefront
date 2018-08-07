module Spree
  class CreditCardsController < Spree::StoreController
    before_action :authenticate_spree_user!
    before_action :load_user

    load_and_authorize_resource class: Spree::CreditCard, find_by: :slug

    before_action :set_account_tab, only: %i[index edit new]
    before_action :load_stripe_payment_method, only: %i[new create]

    def index
      @cards = @user.credit_cards.order(default: :desc)
    end

    def new
      @credit_card = Spree::CreditCard.new(
        payment_method: @stripe_payment_method,
        address: Spree::Address.build_default
      )
      render :new
    end

    def edit; end

    def create
      @credit_card = @user.credit_cards.build(payment_method_params)
      @credit_card.payment_method = @stripe_payment_method

      if @credit_card.save
        redirect_to user_payment_methods_path
      else
        respond_card_with_error
      end
    end

    def update
      if @credit_card.update(card_edit_params)
        flash[:notice] =
          if helpers.saved_as_default?(@credit_card)
            t('payment_methods.cards.set_as_default')
          else
            t('payment_methods.cards.updated')
          end

        redirect_to user_payment_methods_path
      else
        respond_card_with_error
      end
    end

    def destroy
      if @credit_card.destroy
        flash[:success] = t('payment_methods.cards.deleted')
      else
        flash[:error] = card.errors.full_messages.join(', ')
      end

      redirect_back(fallback_location: '/account/payment')
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
      params.require(:credit_card).permit(permitted_source_attributes)
    end

    def card_edit_params
      params.require(:credit_card).permit(permitted_source_attributes + [:id])
    end

    def load_user
      @user = spree_current_user
    end

    def set_account_tab
      @account_tab = :payment
    end

    def load_stripe_payment_method
      @stripe_payment_method = Spree::PaymentMethod.available.find_by(type: 'Spree::Gateway::StripeGateway')
    end
  end
end
