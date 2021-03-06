module Spree
  module BaseHelper
    def meta_data_tags
      meta = meta_data.map do |name, content|
        tag('meta', name: name, content: content)
      end

      meta += meta_properties.map do |name, content|
        tag('meta', property: name, content: content)
      end

      meta.join("\n")
    end

    def quantity_left(variant)
      return 0 if variant.blank?
      current_order ? current_order.quantity_left(variant) : variant.total_on_hand
    end

    def saved_as_default?(object)
      object.saved_changes
            .keys
            .reject { |key| %w[updated_at].include?(key) }
            .all? { |key| key == 'default' }
    end

    def stock_status(requested, available)
      if available.zero?
        :out_of_stock
      elsif available < requested
        :partial
      else
        :available
      end
    end

    def wrap_spans(collection)
      collection.map { |c| [content_tag(:span, c), c] }
    end

    private

    def meta_image
      return if @page&.meta_image&.exists?

      if (image = @product&.images&.first)
        image_url(image.attachment.url(:large))
      else
        image_url('logo/logo-facebook.png')
      end
    end

    def meta_data # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      object = instance_variable_get('@' + controller_name.singularize)
      meta = {}

      if object.is_a? ApplicationRecord
        meta[:keywords] = object.meta_keywords if object[:meta_keywords].present?
        meta[:description] = strip_tags(object.meta_description) if object[:meta_description].present?
      end

      if meta[:description].blank? && object.is_a?(Spree::Product)
        meta[:description] = truncate(strip_tags(object.description), length: 160, separator: ' ')
      end

      if meta[:keywords].blank? || meta[:description].blank?
        meta.reverse_merge!(keywords: current_store.meta_keywords,
                            description: current_store.meta_description)
      end
      meta
    end

    def meta_properties # rubocop:disable Metrics/AbcSize
      opts = {
        'fb:app_id': Rails.application.credentials.facebook_api_key,
        'og:type': @product ? :product : :website
      }

      if (image = meta_image)
        opts['og:image'] = image
      end

      # avoid duplicate
      object_class = instance_variable_get('@' + controller_name.singularize).class.to_s
      objects_with_own_tags = %w[Spree::Page]

      return opts if objects_with_own_tags.include?(object_class)

      opts.merge!(
        'og:title': title,
        'og:description': strip_tags(meta_data[:description])
      )
    end
  end
end
