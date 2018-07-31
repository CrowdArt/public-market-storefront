Spree::Vendor.class_eval do
  def final_rewards
    rewards || Spree::Config.rewards
  end
end
