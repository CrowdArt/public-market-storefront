Deface::Override.new(
  virtual_path: 'spree/checkout/_payment',
  name: 'Add billing address form',
  insert_bottom: 'ul#payment-methods',
  partial: 'spree/checkout/billing_address'
)

Deface::Override.new(
  virtual_path: 'spree/checkout/_payment',
  name: 'Stylize cards radio buttons',
  insert_after: 'div.card_options label',
  text: "<br class='visible-xs-block' />"
)
