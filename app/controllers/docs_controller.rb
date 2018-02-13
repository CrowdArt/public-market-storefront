class DocsController < ApplicationController
  require './app/swagger/root'

  before_action :set_access_control_headers, only: :index

  def index
    render json: Swagger::Blocks.build_root_json(Swagger::Root.swaggered_classes)
  end
end
