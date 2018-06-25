module PublicMarket
  module ProductKind
    extend ActiveSupport::Concern

    def author
      product_properties.joins(:property)
                        .select('spree_product_properties.property_id, spree_product_properties.value, spree_properties.name as property_name')
                        .find_by(spree_properties: { name: author_property_name })
    end

    def image_aspect_ratio
      case taxonomy&.name
      when 'Books'
        21 / 31.to_f
      else
        1
      end
    end

    private

    def author_property_name
      case taxonomy&.name
      when 'Music'
        'artist'
      else
        'author'
      end
    end
  end
end
