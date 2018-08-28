module PublicMarket
  class RewardsValue < BigDecimal
    DIGITS = 10

    def initialize(initial, digits = DIGITS)
      super(initial, digits)
    end

    def *(other)
      self.class.new(super(other))
    end

    def +(other)
      self.class.new(super(other))
    end

    def to_s
      '%g' % ('%.3g' % ('%.2f' % self)) # rubocop:disable Style/FormatString
    end
  end

  class RewardsCalculator
    EXCHANGE_RATE = 0.06

    def self.call(price, rewards)
      rewards_in_usd = price * rewards / 100.0
      RewardsValue.new(rewards_in_usd / EXCHANGE_RATE)
    end
  end
end
