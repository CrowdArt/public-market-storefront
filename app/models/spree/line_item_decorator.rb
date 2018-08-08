Spree::LineItem.class_eval do
  def rewards_amount
    quantity * single_rewards_amount
  end

  def single_rewards_amount
    (price * (rewards || variant.final_rewards) / 100.0).floor(3)
  end
end
