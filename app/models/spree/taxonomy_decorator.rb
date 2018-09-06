module Spree
  module TaxonomyDecorator
    def self.prepended(base)
      class << base
        prepend ClassMethods
      end
    end

    module ClassMethods
      def other
        find_or_create_by!(name: 'Other')
      end
    end

    def variation_module
      "PublicMarket::Variations::#{name.parameterize(separator: '_').camelize}".constantize
    rescue NameError
      PublicMarket::Variations
    end

    def uncategorized_taxon
      root.children.find_or_create_by!(name: Taxon::UNCATEGORIZED_NAME, taxonomy: self, hidden: true)
    end
  end

  Taxonomy.prepend(TaxonomyDecorator)
end
