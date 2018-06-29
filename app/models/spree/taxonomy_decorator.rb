module Spree
  module TaxonomyDecorator
    def variation_module
      "PublicMarket::Variations::#{name.parameterize(separator: '_').camelize}".constantize
    rescue NameError
      nil
    end

    def uncategorized_taxon
      root.children.find_or_create_by!(name: Spree::Taxon::UNCATEGORIZED_NAME, taxonomy: self, hidden: true)
    end
  end

  Taxonomy.prepend(TaxonomyDecorator)
end
