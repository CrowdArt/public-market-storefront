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
    def self.call(price, rewards)
      RewardsValue.new(price * rewards / 100.0)
    end
  end
end
