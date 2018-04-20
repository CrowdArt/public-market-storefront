Deface::Override.new(
  virtual_path: 'spree/shared/_header',
  name: 'Change bootstrap grid on logo',
  set_attributes: 'figure#logo',
  attributes: { class: 'col-sm-2 col-xs-5' }
)
