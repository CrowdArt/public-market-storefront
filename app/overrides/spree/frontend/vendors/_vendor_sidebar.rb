Deface::Override.new(
  virtual_path: 'spree/vendors/_vendor_sidebar',
  name: 'Add rating under vendor name',
  insert_after: '.vendor-page-sidebar .vendor-page-info-name',
  partial: 'spree/ratings/reputation'
)
