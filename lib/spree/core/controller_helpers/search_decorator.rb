module Spree
  module Core
    module ControllerHelpers
      module Search
        def build_searcher(request_params, opts = {})
          search_params = opts.merge(
            request_params.permit(:keywords, :page, :per_page, filter: {}, sort: {}).to_h.symbolize_keys
          )
          search_params[:current_user] = try_spree_current_user

          Spree::Config.searcher_class.new(**search_params)
        end
      end
    end
  end
end
