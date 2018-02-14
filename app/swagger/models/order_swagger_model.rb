module Swagger
  module Schemas
    class OrderSwaggerModel
      include Swagger::Blocks

      swagger_schema :Order do
        property :id do
          key :type, :integer
        end
        property :number do
          key :type, :string
        end
      end

      swagger_schema :OrdersOutput do
        property :orders do
          key :type, :array

          items do
            key :'$ref', :Order
          end
        end

        key :example, orders: [
          {
            number: 'RS2104212',
            status: 'shipped'
          }
        ]
      end
    end
  end
end
