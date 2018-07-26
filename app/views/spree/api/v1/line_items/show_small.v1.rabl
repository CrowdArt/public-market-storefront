object @line_item
cache [I18n.locale, root_object]

node(:sku) { |li| li.variant.sku }
node(:quantity, &:quantity)
node(:ids) { |li| li.inventory_units.map(&:hash_id) }
