Spree::Shipment.class_eval do
  def item_cost
    line_items.map { |li| li.price * li.quantity + li.adjustment_total }.sum
  end
end
