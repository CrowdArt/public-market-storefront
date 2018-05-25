Spree::Variant.class_eval do
  # assume that first option value is main
  def main_option_type
    option_values&.first&.presentation || 'Default'
  end
end
