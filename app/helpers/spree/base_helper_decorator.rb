module Spree
  module BaseHelper
    def variant_options(variant, _options = {})
      variant.option_values
             .includes(:option_type)
             .find_by(spree_option_types: { name: :condition })&.presentation
    end

    def meta_properties
      object_class = instance_variable_get('@' + controller_name.singularize).class.to_s
      objects_with_own_tags = %w[Spree::Page] # avoid duplicate

      return [] if objects_with_own_tags.include?(object_class)
      {
        'og:title': title,
        'og:description': meta_data[:description],
        'fb:app_id': Settings.facebook_api_key,
        'og:type': @product ? :product : :website,
        'og:image': meta_image
      }
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
      if (image = @product&.images&.first)
        image_url(image.attachment.url(:large))
      else
        image_url('logo/logo-facebook.png')
      end
    end
  end
end
