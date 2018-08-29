module PublicMarket
  # TODO: refactor this to use modules, like variations
  module ProductKind
    extend ActiveSupport::Concern

    def subtitle
      @subtitle ||= property(author_property_name)&.titleize
    end

    def product_kind
      @product_kind ||=
        case taxonomy&.name
        when 'Music'
          property(:music_format)&.downcase
        else
          taxonomy&.name&.downcase
        end
    end

    def image_aspect_ratio
      case product_kind
      when 'books'
        21 / 31.to_f
      else
        1
      end
    end

    def identifier_property
      case product_kind
      when 'books'
        property('isbn')
      end
    end

    def additional_properties
      case product_kind
      when 'books'
        [:edition]
      else
        []
      end.map { |p| property(p) }.compact
    end

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
