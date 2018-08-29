module Spree
  module UploadDecorator
    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end

    module ClassMethods
      def supported_product_types
        %w[books music]
      end
    end
  end

  Upload.prepend(UploadDecorator)
end
