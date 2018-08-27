Spree::LineItem.class_eval do
  def rewards_amount
    single_rewards_amount * quantity
  end

  def final_rewards
    rewards || variant.final_rewards
  end

  def single_rewards_amount
    PublicMarket::RewardsCalculator.call(price, final_rewards)
  end
end
