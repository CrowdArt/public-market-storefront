module Swagger
  module Schemas
    class InventoryInputSwaggerModel
      include Swagger::Blocks

      swagger_schema :InventoryInput do
        key :required, %i[sku ean isbn quantity condition unit_price shipping_price]

        property :sku do
          key :type, :string
        end
        property :ean do
          key :type, :string
        end
        property :isbn do
          key :type, :string
        end
        property :quantity do
          key :type, :integer
        end
        property :condition do
          key :type, :string
          key :enum, ['New', 'Refurbished', 'Used - Like New', 'Used - Very Good', 'Used - Good', 'Used - Acceptable']
        end
        property :unit_price do
          key :type, :float
        end
        property :shipping_price do
          key :type, :float
        end

        key :example, ean: '9781472579508',
                      sku: '3-F-2-0034',
                      quantity: 20,
                      price: '52.59',
                      condition: 'Used - Very Good',
                      notes: 'Used but Very Good',
                      seller: 'Black Hand Books'
      end
    end
  end
end
