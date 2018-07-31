class FillLineItemRewards < ActiveRecord::Migration[5.2]
  def up
    Spree::LineItem.includes(:variant).find_each {|li| li.update(rewards: li.variant.final_rewards)}
  end
end
