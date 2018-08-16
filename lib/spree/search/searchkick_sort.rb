module Spree
  module Search
    module SearchkickSort
      def self.applicable_sort_options # rubocop:disable Metrics/MethodLength
        popularity_options = %i[all_time month]
        price_options = %i[asc desc]
        [
          {
            name: 'Price',
            type: :price,
            options: price_options.map do |o|
              { label: I18n.t("filters.sort-options.price.#{o}"), value: o, id: o }
            end
          },
          {
            name: 'Popularity',
            type: :popularity,
            options: popularity_options.map do |o|
              { label: I18n.t("filters.sort-options.popular.#{o}"), value: o, id: o }
            end
          }
        ]
      end
    end
  end
end
