module Spree
  module UploadInventoryWorkerTaxonomy
    def options
      super.merge(taxonomy: 'Books')
    end
  end
end

Spree::UploadInventoryWorker.prepend(Spree::UploadInventoryWorkerDecorator)
