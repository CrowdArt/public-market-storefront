Spree::StockItem.class_eval do
  after_commit :update_product_master_price, if: :saved_change_to_count_on_hand?

  def update_product_master_price
    variant.product.update_best_price unless variant.is_master
  end
end
