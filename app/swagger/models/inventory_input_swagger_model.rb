module Swagger
  module Schemas
    class InventoryInputSwaggerModel
      include Swagger::Blocks

      swagger_schema :BookInventoryInput do
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

      swagger_schema :MusicInventoryInput do
        key :required, %i[sku quantity price format artist title description condition]

        property :sku do
          key :type, :string
        end
        property :quantity do
          key :type, :integer
        end
        property :price do
          key :type, :float
        end
        property :format do
          key :type, :string
          key :enum, ['vinyl']
        end
        property :artist do
          key :type, :string
        end
        property :title do
          key :type, :string
        end
        property :description do
          key :type, :string
        end
        property :condition do
          key :type, :string
          key :enum, ['SS', 'M-', 'VG+', 'VG', 'VG-', 'G+']
        end
        property :notes do
          key :type, :string
        end
        property :label do
          key :type, :string
        end
        property :label_number do
          key :type, :string
        end
        property :speed do
          key :type, :string
        end

        key :example, sku: '3-F-2-0034',
                      quantity: 20,
                      price: 52.59,
                      condition: 'VG',
                      format: 'vinyl',
                      artist: 'Blake Shelton',
                      title: 'Song 1',
                      description: 'Song description',
                      notes: 'Used but Very Good',
                      label: 'Best Label',
                      label_number: 'PK-12',
                      speed: '45'
      end
    end
  end
end
