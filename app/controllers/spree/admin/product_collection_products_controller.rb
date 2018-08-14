module Spree
  module Admin
    class ProductCollectionProductsController < ResourceController
      def destroy
        if @object.destroy
          flash[:success] = flash_message_for(@object, :successfully_removed)
          respond_with(@object) do |format|
            format.html { redirect_to location_after_destroy }
            format.js   { render_js_for_destroy }
          end
        else
          render plain: @object.errors.full_messages.join(', '), status: :unprocessable_entity
        end
      end

      private

      def find_resource
        ProductCollectionProduct.find(params[:id])
      end
    end
  end
end
