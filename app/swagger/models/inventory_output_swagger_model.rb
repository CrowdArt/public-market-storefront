module Swagger
  module Schemas
    class InventoryOutputSwaggerModel
      include Swagger::Blocks

      swagger_schema :InventoryOutput do
        property :items do
          key :type, :array

          items do
            property :sku do
              key :type, :string
            end

            property :quantity do
              key :type, :integer
            end

            property :updated_at do
              key :type, :datetime
            end
          end
        end

        property :total_count do
          key :type, :integer
        end

        property :total_pages do
          key :type, :integer
        end

        key :example, items: [
          { sku: 'DC3439-201-01N', quantity: 1, updated_at: '2018-08-13T11:25:25.234Z' },
          { sku: 'DC1200-002-02S', quantity: 0, updated_at: '2018-08-13T11:25:56.085Z' }
        ], total_count: 2, total_pages: 1
      end
    end
  end
end
