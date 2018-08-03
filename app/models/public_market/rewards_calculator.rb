module PublicMarket
  class RewardsCalculator
    def self.call(price, rewards)
      (price * rewards / 100.0).floor(3)
    end
  end
end
