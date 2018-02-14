module Swagger
  module Controllers
    class OrderSwaggerModel
      include Swagger::Blocks

      swagger_schema :Order do
        property :id do
          key :type, :integer
        end
        property :number do
          key :type, :string
        end
      end
    end
  end
end
