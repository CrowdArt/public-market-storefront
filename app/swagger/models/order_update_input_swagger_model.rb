module Swagger
  module Schemas
    class OrderUpdateInputSwaggerModel
      include Swagger::Blocks

      swagger_schema :OrderUpdateInput do
        property :updates do
          key :type, :array

          items do
            property :order_number do
              key :type, :string
            end

            property :item_number do
              key :type, :string
            end

            property :action do
              key :type, :string
              key :enum, %i[confirm cancel]
            end

            property :tracking_number do
              key :type, :string
            end

            property :shipped_at do
              key :type, :string
            end
          end
        end

        key :example, updates: [
          {
            order_number: 'RS2104212',
            item_number: '434011',
            action: 'ship',
            tracking_number: '10042300020233232',
            shipped_at: '1531757362'
          }
        ]
      end
    end
  end
end
