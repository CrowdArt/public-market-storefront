module PublicMarket
  class RewardsCalculator
    def self.call(price, rewards)
      RewardsValue.new(price * rewards / 100.0)
    end
  end
end
