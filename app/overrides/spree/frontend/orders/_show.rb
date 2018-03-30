Deface::Override.new(
  virtual_path: 'spree/orders/show',
  name: 'Add rating form',
  insert_before: '#order',
  partial: 'spree/ratings/form'
)
