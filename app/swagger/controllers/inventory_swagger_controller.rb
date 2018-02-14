module Swagger
  module Schemas
    class InventorySwaggerController < BaseSwaggerController
      swagger_path '/inventory/{content_format}' do
        operation :post do
          key :summary, 'Upload inventory'
          key :description, 'Uploads inventory within given file with inventory items'

          key :tags, [:inventory]

          key :consumes, ['application/json', 'text/csv']

          security do
            key :spree_token, []
          end

          parameter do
            key :name, :content_format
            key :description, 'Content format'
            key :in, :path
            key :required, true
            key :type, :string
            key :enum, %i[json csv]
          end

          parameter do
            key :name, :content
            key :description, 'Inventory items'
            key :in, :body
            key :required, true
            key :type, :string

            schema do
              property :content do
                property :items do
                  key :type, :array
                  items do
                    key :'$ref', :InventoryInput
                  end
                end
              end
            end
          end

          extend SwaggerResponses::AuthenticationError
          response 200 do
            key :description, 'Returns sidekiq job id'
          end
        end
      end
    end
  end
end
