object false
child(@items => :items) do
  object @item

  node(:sku, &:sku)
  node(:quantity, &:total_on_hand)
  node(:updated_at, &:updated_at)
end

node(:total_count) { @items.total_count }
node(:total_pages) { @items.total_pages }
