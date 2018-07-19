Spree::OrderUpdater.class_eval do
  def line_items
    order.line_items.where.not(state: :canceled)
  end
end
