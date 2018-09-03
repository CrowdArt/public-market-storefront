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
end