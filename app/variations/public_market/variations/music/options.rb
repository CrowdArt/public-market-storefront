module PublicMarket
  module Variations
    module Music
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
            'like new' => [
              'ss',
              'm-',
              'vg+'
            ],
            'used' => [
              'vg',
              'vg-',
              'g+'
            ]
          }
        end
      end
    end
  end
end
