Spree::Product.class_eval do
  def author
    product_properties.joins(:property)
                      .where("spree_properties.name = 'author' OR spree_properties.name = 'manufacturer'")
                      .select('spree_product_properties.property_id, spree_product_properties.value, spree_properties.name as property_name')
                      .first
  end
end
