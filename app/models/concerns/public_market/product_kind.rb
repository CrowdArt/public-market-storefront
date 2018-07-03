module PublicMarket
  module ProductKind
    extend ActiveSupport::Concern

    def subtitle
      property(author_property_name)
    end

    def image_aspect_ratio
      case taxonomy&.name
      when 'Books'
        21 / 31.to_f
      else
        1
      end
    end

    def identifier_property
      case taxonomy&.name
      when 'Books'
        property('isbn')
      end
    end

    def additional_properties
      case taxonomy&.name
      when 'Books'
        [:edition]
      else
        []
      end.map { |p| property(p) }.compact
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
