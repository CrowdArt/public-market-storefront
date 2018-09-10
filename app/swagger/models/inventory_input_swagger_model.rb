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

      swagger_schema :GenericInventoryInput do
        key :required, %i[sku product_id categories quantity price]

        property :sku do
          key :type, :string
        end
        property :product_id do
          key :type, :string
          key :description, 'Product identifier: ISBN/UPC/EAN/...'
        end
        property :categories do
          key :type, :array
          key :description, 'Product categories as array or comma-delimited string'
          items do
            key :type, :string
          end
        end
        property :quantity do
          key :type, :integer
        end
        property :price do
          key :type, :float
        end

        property :title do
          key :type, :string
        end
        property :description do
          key :type, :string
        end
        property :notes do
          key :type, :string
        end
        property :option_types do
          key :type, :array
          key :description, 'Array of option names or comma-delimited string. E.g: "color", so color value should be defined in input data'
          items do
            key :type, :string
          end
        end
        property :images do
          key :type, :array
          key :description, 'Product images as array or comma-delimited string of urls'
          items do
            key :type, :string
          end
        end
        property :weight do
          key :type, :float
        end
        property :height do
          key :type, :float
        end
        property :width do
          key :type, :float
        end
        property :depth do
          key :type, :float
        end
        property :rewards_percentage do
          key :type, :integer
        end
        property :keywords do
          key :type, :string
          key :description, 'String of keywords/tags delimited by space'
        end

        key :example, sku: 'WBL-001-RGB',
                      product_id: '87667573893',
                      categories: ['Wireless'],
                      quantity: 5,
                      price: 3.99,
                      title: 'Title',
                      description: 'Description',
                      notes: 'Notes',
                      option_types: ['color'],
                      images: ['https://fakeimg.pl/500x500/?text=World&font=lobster'],
                      weight: 3.44,
                      height: 5.12,
                      width: 2,
                      depth: 0.12,
                      rewards_percentage: 1,
                      color: 'Red',
                      size: 'XL',
                      brand: 'Brand',
                      other_unique_property: 'Example',
                      keywords: 'keyword1 keyword2 keyword3'
      end

      swagger_schema :MusicInventoryInput do
        key :required, %i[sku quantity price format artist title description condition images]

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
        property :genres do
          key :type, :string
        end
        property :images do
          key :type, :array
        end

        key :example, sku: '3-F-2-0034',
                      quantity: 20,
                      price: 52.59,
                      condition: 'VG',
                      format: 'vinyl',
                      artist: 'Blake Shelton',
                      title: 'Song 1',
                      description: 'Record description',
                      notes: 'Used but Very Good',
                      label: 'Best Label',
                      label_number: 'PK-12',
                      genres: 'Hardcore',
                      speed: '45',
                      images: ['https://fakeimg.pl/200', 'https://fakeimg.pl/300', 'https://fakeimg.pl/400']
      end
    end
  end
end
