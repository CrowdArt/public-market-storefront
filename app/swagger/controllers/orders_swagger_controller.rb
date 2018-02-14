module Swagger
  module Controllers
    require_relative './base_controller'

    class OrdersSwaggerController < BaseController
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
            key :description, 'Timestamp of last fetched order'
            key :in, :query
            key :required, false
            key :type, :string
          end

          extend SwaggerResponses::AuthenticationError
          response 200 do
            key :description, 'Returns array with orders'
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
            key :in, :form
            key :required, true
            key :type, :array
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
