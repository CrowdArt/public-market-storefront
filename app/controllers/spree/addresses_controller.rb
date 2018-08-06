module Spree
  class AddressesController < Spree::StoreController
    before_action :authenticate_spree_user!
    load_and_authorize_resource class: Spree::Address

    before_action :load_user, only: %i[index create]
    before_action :set_account_tab, only: %i[index edit new]

    def index
      @addresses = @user.addresses.order(default: :desc)
    end

    def create
      @address = @user.addresses.build(address_params)

      if @address.save
        flash[:notice] = t('addresses.successfully_created')
        redirect_to user_addresses_path
      else
        render action: :new
      end
    end

    def edit; end

    def new
      @address = Spree::Address.default
    end

    def update
      if @address.update(address_params)
        flash[:notice] = t('addresses.updated')
        redirect_to user_addresses_path
      else
        render action: :edit
      end
    end

    def destroy
      if @address.destroy
        flash[:success] = t('addresses.successfully_removed')
      else
        flash[:error] = @address.errors.full_messages.join(', ')
      end

      redirect_to user_addresses_path
    end

    private

    def set_account_tab
      @account_tab = :shipping
    end

    def address_params
      params.require(:address).permit(Spree::PermittedAttributes.address_attributes + [:default])
    end

    def load_user
      @user = spree_current_user
    end
  end
end
