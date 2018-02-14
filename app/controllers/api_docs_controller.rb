class ApiDocsController < ApplicationController
  require './app/swagger/root'

  def index
    render :index
  end

  def schema
    render json: Swagger::Blocks.build_root_json(Swagger::Root.swaggered_classes)
  end
end
