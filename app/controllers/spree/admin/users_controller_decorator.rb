module Spree
  module Admin
    module UsersControllerDecorator
      private

      def find_resource
        User.with_deleted.friendly.find(params[:id])
      end
    end

    UsersController.prepend(UsersControllerDecorator)
  end
end
