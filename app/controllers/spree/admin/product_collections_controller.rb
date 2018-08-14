module Spree
  module Admin
    class ProductCollectionsController < ResourceController
      def index
        respond_with(@collection)
      end

      def edit
        @product_collection_products =
          @object.product_collections_products
                 .joins(:product)
                 .page(params[:page])
                 .per(Spree::Config[:admin_properties_per_page])

        super
      end

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
        ProductCollection.friendly.find(params[:id])
      end

      def collection
        return @collection if @collection.present?
        params[:q] = {} if params[:q].blank?

        @collection = super
        @search = @collection.ransack(params[:q])
        @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_properties_per_page])
      end
    end
  end
end
