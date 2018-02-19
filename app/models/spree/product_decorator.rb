Spree::Product.class_eval do
  include Spree::Core::NumberGenerator.new(prefix: 'PM', letters: true, length: 13)

  def author
    product_properties.joins(:property)
                      .where("spree_properties.name = 'author' OR spree_properties.name = 'manufacturer'")
                      .select('spree_product_properties.property_id, spree_product_properties.value, spree_properties.name as property_name')
                      .first
  end

  def self.autocomplete_fields
    %i[name author]
  end

  def self.search_fields
    %i[name author isbn]
  end
end
