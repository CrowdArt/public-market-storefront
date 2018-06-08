Spree::Taxonomy.class_eval do
  def variation_module
    "PublicMarket::Variations::#{name.parameterize(separator: '_').classify}Variation".constantize
  rescue NameError
    nil
  end
end
