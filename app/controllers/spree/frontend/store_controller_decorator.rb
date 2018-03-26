Spree::StoreController.class_eval do
  def hide_search_bar_on_mobile
    @hide_search_bar_mobile = true
  end

  def set_back_mobile_link(link)
    @back_mobile_link = link
  end
end
