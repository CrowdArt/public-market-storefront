Spree::ProductProperty.class_eval do
  def value
    case property_name
    when 'published_at'
      I18n.l(Date.parse(super)) if super.present?
    else
      super
    end
  end
end
