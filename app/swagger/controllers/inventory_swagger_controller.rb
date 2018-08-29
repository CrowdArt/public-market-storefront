module Swagger
  module Schemas
    class InventorySwaggerController < BaseSwaggerController
      swagger_path '/inventory/fetch' do
        operation :get do
          key :summary, 'Fetch inventory'
          key :description, 'Fetch actual inventory'

          key :tags, [:inventory]

          security do
            key :pm_token, []
          end

          parameter do
            key :name, :page
            key :description, 'Page number'
            key :in, :query
            key :required, false
            key :type, :integer
            key :example, 1
          end

          parameter do
            key :name, :per_page
            key :description, 'Number of items per page'
            key :in, :query
            key :required, false
            key :type, :integer
            key :example, 25
          end

          extend SwaggerResponses::AuthenticationError

          response 200 do
            key :description, 'Returns array with items'
            schema do
              key :type, :object
              key :'$ref', :InventoryOutput
            end
          end
        end
      end

      swagger_path '/inventory/{content_format}/{product_type}' do
        operation :post do
          key :summary, 'Upload inventory'
          key :description, 'Uploads inventory within given file with inventory items'

          key :tags, [:inventory]

          key :consumes, ['application/json', 'text/csv']

          security do
            key :pm_token, []
          end

          parameter do
            key :name, :content_format
            key :description, 'Upload format (json or csv)'
            key :in, :path
            key :required, true
            key :type, :string
            key :enum, %i[json csv]
            key :example, :json
          end

          parameter do
            key :name, :product_type
            key :description, 'Product type'
            key :in, :path
            key :required, true
            key :type, :string
            key :enum, Spree::Upload.supported_product_types
            key :example, :books
          end

          parameter do
            key :name, :body
            key :description, 'Inventory items'
            key :in, :body
            key :required, true

            schema do
              property :items do
                key :type, :array
                items do
                  key :'$ref', :BookInventoryInput
                end
              end
            end
          end

          extend SwaggerResponses::AuthenticationError
          response 200 do
            key :description, 'Returns async job id'
          end
        end
      end

      swagger_path '/inventory/{content_format}/music' do
        operation :post do
          key :summary, 'Upload inventory'
          key :description, 'Uploads inventory within given file with inventory items'

          key :tags, [:inventory]

          key :consumes, ['application/json', 'text/csv']

          security do
            key :pm_token, []
          end

          parameter do
            key :name, :content_format
            key :description, 'Upload format (json or csv)'
            key :in, :path
            key :required, true
            key :type, :string
            key :enum, %i[json csv]
            key :example, :json
          end

          parameter do
            key :name, :product_type
            key :description, 'Product type'
            key :in, :path
            key :required, true
            key :type, :string
            key :enum, %i[music]
            key :example, :music
          end

          parameter do
            key :name, :body
            key :description, 'Inventory items'
            key :in, :body
            key :required, true

            schema do
              property :items do
                key :type, :array
                items do
                  key :'$ref', :MusicInventoryInput
                end
              end
            end
          end

          extend SwaggerResponses::AuthenticationError
          response 200 do
            key :description, 'Returns async job id'
          end
        end
      end
    end
  end
end
