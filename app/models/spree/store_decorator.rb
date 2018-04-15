Spree::Store.class_eval do
  def meta_description
    self[:meta_description].presence || Spree.t(:default_meta_description, default: nil)
  end
end
