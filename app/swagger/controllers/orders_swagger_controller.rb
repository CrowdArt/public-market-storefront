module Swagger
  module Schemas
    class OrdersSwaggerController < BaseSwaggerController
      swagger_path '/orders/fetch' do
        operation :get do
          key :summary, 'Fetch orders'
          key :description, 'Fetch orders'

          key :tags, [:orders]

          security do
            key :spree_token, []
          end

          parameter do
            key :name, :from_timestamp
            key :description, 'Timestamp of last fetched order in milliseconds'
            key :in, :query
            key :required, false
            key :type, :string
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

      swagger_path '/orders/update_shipments' do
        operation :post do
          key :summary, 'Update shipment status'
          key :description, 'Update shipment status of given shipment'

          key :tags, [:orders]

          security do
            key :spree_token, []
          end

          parameter do
            key :name, :orders
            key :description, 'Array of order numbers'
            key :in, :body
            key :required, true
            schema do
              key :type, :object
              key :'$ref', :ShipmentInput
            end
          end

          extend SwaggerResponses::AuthenticationError
          response 200 do
            key :description, 'Returns count of succesfully updated orders'
          end
        end
      end
    end
  end
end
