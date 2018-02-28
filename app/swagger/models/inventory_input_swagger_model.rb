module Swagger
  module Schemas
    class InventoryInputSwaggerModel
      include Swagger::Blocks

      swagger_schema :InventoryInput do
        key :required, %i[ean sku quantity price condition notes]

        property :ean do
          key :type, :string
          key :description, 'ISBN'
        end
        property :sku do
          key :type, :string
        end
        property :quantity do
          key :type, :integer
        end
        property :price do
          key :type, :float
        end
        property :condition do
          key :type, :string
          key :enum, ['New', 'Like New', 'Excellent', 'Very Good', 'Good', 'Acceptable']
        end
        property :notes do
          key :type, :string
        end

        key :example, ean: '9781472579508',
                      sku: '3-F-2-0034',
                      quantity: 20,
                      price: 52.59,
                      condition: 'Very Good',
                      notes: 'Used but Very Good',
                      seller: 'Best Market'
      end
    end
  end
end
