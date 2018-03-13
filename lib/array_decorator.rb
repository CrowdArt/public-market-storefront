class Array
  def median
    sorted = self.sort # rubocop:disable Style/RedundantSelf
    middle_position = sorted.length / 2
    return sorted[middle_position] if sorted.size.odd?
    (sorted[middle_position - 1] + sorted[middle_position]) / 2
  end
end
