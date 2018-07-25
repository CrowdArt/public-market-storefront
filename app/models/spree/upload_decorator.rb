module Spree
  module UploadDecorator
    def self.prepended(_base)
      Spree::Upload.const_set('SUPPORTED_PRODUCT_TYPES', %w[books music])
    end
  end

  Upload.prepend(UploadDecorator)
end
