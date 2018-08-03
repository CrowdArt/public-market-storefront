module Swagger
  module Schemas
    class OrderSwaggerModel
      include Swagger::Blocks

      swagger_schema :Shipping_address do
        property :firstname do
          key :type, :string
        end
        property :lastname do
          key :type, :string
        end
        property :address1 do
          key :type, :string
        end
        property :address2 do
          key :type, :string
        end
        property :city do
          key :type, :string
        end
        property :zipcode do
          key :type, :integer
        end
        property :phone do
          key :type, :string
        end
        property :alternative_phone do
          key :type, :string
        end
        property :country do
          key :type, :string
        end
        property :state do
          key :type, :string
        end
      end

      swagger_schema :Line_item do
        property :id do
          key :type, :string
        end
        property :sku do
          key :type, :string
        end
        property :name do
          key :type, :string
        end
        property :price do
          key :type, :float
        end
        property :quantity do
          key :type, :integer
        end
      end

      swagger_schema :Order do
        property :shipping_address do
          key :'$ref', :Shipping_address
        end

        property :line_items do
          key :type, :array

          items do
            key :'$ref', :Line_item
          end
        end

        property :order_number do
          key :type, :string
        end

        property :id do
          key :type, :string
        end

        property :created_at do
          key :type, :datetime
        end

        property :total do
          key :type, :float
        end

        property :shipping_cost do
          key :type, :float
        end
      end

      swagger_schema :OrdersOutput do
        property :orders do
          key :type, :array

          items do
            key :'$ref', :Order
          end
        end

        key :example,
            orders: [
              {
                shipping_address: {
                  firstname: 'Peter',
                  lastname: 'Evans',
                  address1: 'Folsom 1519, SF',
                  address2: 'California, US',
                  city: 'San Francisco',
                  zipcode: 94001, # rubocop:disable Style/NumericLiterals
                  phone: '+19997104099',
                  alternative_phone: 'null',
                  country: 'US',
                  state: 'CA'
                },
                line_items: [
                  {
                    sku: 'PIDC790519MCMPDYY8',
                    name: 'Listing Name',
                    price: '2.99',
                    quantity: 1,
                    ids: ['32323']
                  }
                ],
                id: '12323',
                order_number: 'PM2104212',
                created_at: '2018-02-16T11:15:00.093Z',
                total: '2.99',
                shipping_cost: '0.0'
              }
            ],
            count: 1
      end
    end
  end
end
