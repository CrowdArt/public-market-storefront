module Swagger
  class BaseSwaggerController
    require_relative '../responses'

    include Swagger::Blocks
  end
end
