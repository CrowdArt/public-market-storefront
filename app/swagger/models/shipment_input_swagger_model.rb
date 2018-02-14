module Swagger
  module Schemas
    class ShipmentInputSwaggerModel
      include Swagger::Blocks

      swagger_schema :ShipmentInput do
        property :orders do
          key :type, :array

          items do
            property :number do
              key :type, :string
            end

            property :action do
              key :type, :string
              key :enum, %i[cancel ready ship]
            end
          end
        end

        key :example, orders: [
          {
            number: 'RS2104212',
            action: 'ship'
          }
        ]
      end
    end
  end
end
