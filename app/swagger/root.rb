require_relative 'controllers/base_swagger_controller'

%w[models controllers].each do |path|
  Dir.glob(File.join(File.dirname(__FILE__), "#{path}/*.rb")) do |c|
    Rails.configuration.cache_classes ? require(c) : load(c)
  end
end

module Swagger
  module Root
    include Swagger::Blocks

    swagger_root do
      key :swagger, '2.0'

      info do
        key :version, '0.0.1'
        key :title, 'Public market'
        key :description, 'Public market API specification'
        key :termsOfService, 'https://publicmarket.io/terms/'
        contact do
          key :name, 'Public market team'
        end
        license do
          key :name, 'MIT'
        end
      end

      tag do
        key :name, 'orders'
        key :description, 'Operations on orders'
      end

      tag do
        key :name, 'inventory'
        key :description, 'Operations on inventory'
      end

      key :host, Rails.env.development? ? '0.0.0.0:5000' : 'storefront.simbi.com'
      key :basePath, '/api/v1'
      key :consumes, ['application/json']
      key :produces, ['application/json']

      security_definition :spree_token do
        key :type, :apiKey
        key :name, 'X-Spree-Token'
        key :in, :header
      end
    end

    def self.swaggered_classes
      classes = [self]

      swagger_controllers =
        Swagger::Controllers.constants.each_with_object([]) do |c, consts|
          cc = Swagger::Controllers.const_get(c)
          consts << cc if cc.is_a?(Class)
          consts
        end

      classes.push(*swagger_controllers)
      classes
    end
  end
end
