Spree::Taxon.class_eval do
  scope :visible, -> { where(hidden: false) }
  scope :hidden, -> { where(hidden: true) }
end
