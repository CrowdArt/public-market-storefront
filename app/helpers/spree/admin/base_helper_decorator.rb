Spree::Admin::BaseHelper.class_eval do
  def rewards_options(selected)
    options_for_select((1..20).map {|p| ["#{p}%", p] }, selected)
  end
end
