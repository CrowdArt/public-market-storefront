FactoryBot.define do
  factory :classification, class: Spree::Classification do
    taxon
    product
  end
end
