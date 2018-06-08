module Spree
  module Search
    module SearchkickSort
      def self.applicable_sort_options(taxon)
        return unless taxon.root.permalink == 'books'

        options = %i[all_time month]
        [
          {
            name: 'Popularity',
            type: :popularity,
            options: options.map do |o|
              { label: I18n.t("filters.sort-options.popular.#{o}"), value: o, id: o }
            end
          }
        ]
      end
    end
  end
end
