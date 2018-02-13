module Swagger
  module Controllers
    class BaseController
      require_relative '../responses'

      include Swagger::Blocks
    end
  end
end
