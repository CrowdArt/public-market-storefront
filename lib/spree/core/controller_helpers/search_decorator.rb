module Spree
  module Core
    module ControllerHelpers
      module Search
        ALLOWED_PER_PAGE = %w[12 24 36 48 60].freeze
        ALLOWED_FILTER_PARAMS = { format: [], variations: [], collections: [] }.freeze

        def build_searcher(request_params, opts: {}, searcher_class: Spree::Config.searcher_class)
          request_params[:per_page] =
            if ALLOWED_PER_PAGE.include?(request_params[:per_page])
              request_params[:per_page]
            else
              Spree::Config[:products_per_page]
            end

          search_params = opts.merge(
            request_params.permit(:keywords, :page, :per_page, filter: ALLOWED_FILTER_PARAMS, sort: {}).to_h.symbolize_keys
          )
          search_params[:current_user] = try_spree_current_user

          searcher_class.new(**search_params)
        end
      end
    end
  end
end
