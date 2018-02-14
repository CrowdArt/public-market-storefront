module Swagger
  module Controllers
    class BaseSwaggerController
      require_relative '../responses'

      include Swagger::Blocks
    end
  end
end
