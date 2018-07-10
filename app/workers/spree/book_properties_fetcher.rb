module Spree
  class BookPropertiesFetcher
    include Sidekiq::Worker
    sidekiq_options queue: :recalculation

    def perform(product_id)
      product = Spree::Product.find(product_id)

      isbn = product.property('isbn')

      metadata = Inventory::Providers::Books::BowkerMetadataProvider.call(isbn)

      return if metadata.blank?

      Product.transaction do
        build_product_master(product, metadata)

        product.name = product.meta_title = metadata[:title]
        product.description = product.meta_description = metadata[:description]
        product.meta_keywords = metadata.dig(:properties, :subject)

        product.save!

        set_properties(product, metadata[:properties])
      end
    end

    private

    def set_properties(product, properties)
      properties.each do |property_name, property_value|
        if property_value.present?
          product.set_property(property_name, property_value, I18n.t("properties.#{property_name}", default: property_name.to_s.humanize))
        end
      end
    end

    def build_product_master(product, metadata)
      product.master.assign_attributes(master_variant_attributes(metadata))
      return if metadata[:images].blank?
      product.master.images = []
      metadata[:images].each do |img|
        product.master.images.build(
          alt: img[:title],
          attachment: img[:file]
        )
      end
    end

    def master_variant_attributes(metadata)
      dims = metadata[:dimensions]
      {
        weight: dims[:weight],
        height: dims[:height],
        width: dims[:width],
        depth: dims[:depth]
      }
    end
  end
end
