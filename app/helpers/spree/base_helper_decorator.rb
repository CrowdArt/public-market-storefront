module Spree
  module BaseHelper
    def variant_options(v, _options = {})
      v.option_values.includes(:option_type).find_by(spree_option_types: { name: :condition }).presentation
    end
  end
end
