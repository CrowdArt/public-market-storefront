object false
child(@orders => :orders) do
  object @order

  node(:order_number, &:number)
  node(:id, &:hash_id)
  node(:created_at, &:completed_at)
  node(:total, &:total)
  node(:shipping_cost, &:ship_total)

  child shipping_address: :shipping_address do
    extends 'spree/api/v1/addresses/show_small'
  end

  child line_items: :line_items do
    extends 'spree/api/v1/line_items/show_small'
  end
end

node(:count) { @orders.count }
