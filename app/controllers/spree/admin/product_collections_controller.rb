module Spree
  module Admin
    class ProductCollectionsController < ResourceController
      def index
        respond_with(@collection)
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
