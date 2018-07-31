Spree::Price.class_eval do
  after_commit :update_product_master_price, if: :saved_change_to_amount?

  def update_product_master_price
    variant.product.update_best_variant unless variant.is_master
  end
end
