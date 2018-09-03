Deface::Override.new(
  virtual_path: 'spree/admin/orders/_shipment',
  name: 'Remove shipping method edit',
  remove: 'tr.show-method'
)
