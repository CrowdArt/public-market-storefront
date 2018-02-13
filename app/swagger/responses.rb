module Swagger
  module SwaggerResponses
    module AuthenticationError
      def self.extended(base)
        base.response 401 do
          key :description, 'Unathorized'
        end
      end
    end
  end
end
