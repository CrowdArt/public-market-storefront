module Swagger
  module Controllers
    class InventorySwaggerController < BaseController
      swagger_path '/inventory/{content_format}' do
        operation :post do
          key :summary, 'Upload inventory'
          key :description, 'Uploads inventory within given file with inventory items'

          key :tags, [:inventory]

          security do
            key :spree_token, []
          end

          parameter do
            key :name, :content_format
            key :description, 'Content format'
            key :in, :path
            key :required, true
            key :type, :string
            key :enum, %i[csv json]
          end

          parameter do
            key :name, :content
            key :description, 'File content'
            key :in, :formData
            key :required, true
            key :type, :string
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
