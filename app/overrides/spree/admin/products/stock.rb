Deface::Override.new(
  virtual_path: 'spree/admin/products/stock',
  name: 'Remove backorderable header in stock items edit table for vendors',
  surround: '.stock_location_info thead th:nth-child(3)',
  text: '<% if current_spree_vendor.blank? %><%= render_original %><% end %>'
)

Deface::Override.new(
  virtual_path: 'spree/admin/products/stock',
  name: 'Remove backorderable column in stock items edit table for vendors',
  surround: '.stock_location_info tbody td:nth-child(3)',
  text: '<% if current_spree_vendor.blank? %><%= render_original %><% end %>'
)
