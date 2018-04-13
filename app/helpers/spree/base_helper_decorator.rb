module Spree
  module BaseHelper
    def variant_options(variant, _options = {})
      variant.option_values
             .includes(:option_type)
             .find_by(spree_option_types: { name: :condition })&.presentation
    end

    def meta_properties
      opts = {
        'fb:app_id': Settings.facebook_api_key,
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
        'og:description': meta_data[:description]
      )
    end

    def meta_data_tags
      meta = meta_data.map do |name, content|
        tag('meta', name: name, content: content)
      end

      meta += meta_properties.map do |name, content|
        tag('meta', property: name, content: content)
      end

      meta.join("\n")
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
  end
end
