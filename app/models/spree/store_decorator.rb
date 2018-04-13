Spree::Store.class_eval do
  def meta_description
    super.presence || Spree.t(:default_meta_description, default: nil)
  end
end
