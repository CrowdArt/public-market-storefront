module Spree
  module TaxonDecorator
    UNCATEGORIZED_NAME = 'Uncategorized'.freeze

    def self.prepended(base)
      base.scope :visible, -> { where(hidden: false) }
      base.scope :hidden, -> { where(hidden: true) }
    end
  end

  Taxon.prepend(TaxonDecorator)
end
