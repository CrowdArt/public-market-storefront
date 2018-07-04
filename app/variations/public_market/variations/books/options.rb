module PublicMarket
  module Variations
    module Books
      module Options
        module_function

        def condition(condition)
          conditions.find { |_k, v| v.include?(condition.downcase) }&.first || condition
        end

        def conditions
          {
            'new' => [
              'new'
            ],
            'used' => [
              'like new',
              'excellent',
              'very good',
              'good',
              'acceptable'
            ],
            'collectable' => ['collectable']
          }
        end
      end
    end
  end
end
