module Spree
  module UploadInventoryWorkerTaxonomyDecorator
    def options
      super.merge(taxonomy: 'Books')
    end
  end
end

Spree::UploadInventoryWorker.prepend(Spree::UploadInventoryWorkerTaxonomyDecorator)
