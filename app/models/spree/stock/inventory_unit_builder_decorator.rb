# Spree::Stock::InventoryUnitBuilder.class_eval do
#   def units
#     @order.line_items.map do |line_item|
#       Array.new(line_item.quantity).map do
#         # They go through multiple splits, avoid loading the
#         # association to order until needed.
#         Spree::InventoryUnit.new(
#           pending:    true,
#           line_item:  line_item,
#           variant:    line_item.variant,
#           quantity:   1,
#           order_id:   @order.id
#         )
#       end
#     end.flatten
#   end
# end
