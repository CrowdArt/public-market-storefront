Deface::Override.new(
  virtual_path: 'spree/admin/shared/_account_nav',
  name: 'Remove redundant admin account menu items',
  remove: 'hr',
  closing_selector: 'li:last-of-type'
)
