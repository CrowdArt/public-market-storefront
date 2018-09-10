Spree::Admin::BaseHelper.class_eval do
  def rewards_options(selected)
    options_for_select((5..30).map { |p| ["#{p}%", p] }, selected)
  end
end
