module Spree
  module ProductKind
    extend ActiveSupport::Concern

    delegate :subtitle, :image_aspect_ratio, :additional_properties, :products_by_subtitle,
             :author_property_name, :product_description, :product_date,
             to: :product_kind, allow_nil: true

    def product_kind_name
      return @product_kind_name if defined?(@product_kind_name)
      @product_kind_name = taxonomy&.name&.downcase
    end

    def product_kind
      return @product_kind if @product_kind || product_kind_name.blank?
      kind_class = ProductKinds.const_get(product_kind_name.parameterize(separator: '_').camelize)
      @product_kind = kind_class.new(self)
    rescue NameError
      @product_kind = ProductKinds::Base.new(self)
    end
  end
end
