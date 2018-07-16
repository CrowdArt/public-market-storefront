module Swagger
  module Schemas
    class OrdersSwaggerController < BaseSwaggerController
      swagger_path '/orders/fetch' do
        operation :get do
          key :summary, 'Fetch orders'
          key :description, 'Fetch orders'

          key :tags, [:orders]

          security do
            key :pm_token, []
          end

          parameter do
            key :name, :from_timestamp
            key :description, 'Timestamp of last fetched order in milliseconds'
            key :in, :query
            key :required, false
            key :type, :integer
            key :example, 1.week.ago.to_i
          end

          extend SwaggerResponses::AuthenticationError

          response 200 do
            key :description, 'Returns array with orders'
            schema do
              key :type, :object
              key :'$ref', :OrdersOutput
            end
          end
        end
      end

      swagger_path '/orders/update' do
        operation :post do
          key :summary, 'Update order items status'
          key :description, 'Update order items status of given orders'

          key :tags, [:orders]

          security do
            key :pm_token, []
          end

          parameter do
            key :name, :orders
            key :description, 'Array of updates'
            key :in, :body
            key :required, true
            schema do
              key :type, :object
              key :'$ref', :OrderUpdateInput
            end
          end

          extend SwaggerResponses::AuthenticationError
          response 200 do
            key :description, 'Returns hash of updated items'
          end
        end
      end
    end
  end
end
