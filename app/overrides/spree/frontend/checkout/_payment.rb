Deface::Override.new(
  virtual_path: 'spree/checkout/_payment',
  name: 'Add billing address form',
  insert_bottom: 'ul#payment-methods',
  partial: 'spree/checkout/billing_address'
)
