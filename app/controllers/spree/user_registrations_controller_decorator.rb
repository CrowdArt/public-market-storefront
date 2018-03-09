module Spree
  module UserRegistrationsControllerDecorator
    protected

    def set_flash_message(key, kind, options = {})
      super(key, kind, options.merge(email: resource&.email))
    end
  end
end

Spree::UserRegistrationsController.prepend(Spree::UserRegistrationsControllerDecorator)