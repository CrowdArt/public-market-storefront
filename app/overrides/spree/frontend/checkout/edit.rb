Deface::Override.new(
  virtual_path: 'spree/checkout/edit',
  name: 'Remove email field in checkout flow',
  remove: 'erb[silent]:contains("if @order.state == \'address\' || !@order.email?")',
  closing_selector: "erb[silent]:contains('end')"
)
