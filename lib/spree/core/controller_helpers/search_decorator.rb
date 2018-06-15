module Spree
  module Core
    module ControllerHelpers
      module Search
        ALLOWED_PER_PAGE = %w[20 30 40 50].freeze

        def build_searcher(request_params, opts = {})
          request_params[:per_page] =
            if ALLOWED_PER_PAGE.include?(request_params[:per_page])
              request_params[:per_page]
            else
              Spree::Config[:products_per_page]
            end

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
