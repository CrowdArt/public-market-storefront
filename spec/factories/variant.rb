FactoryBot.define do
  factory :book_variant, parent: :variant do
    after(:build) do |variant, _evaluator|
      variant.product.taxons << Spree::Taxonomy.first_or_create(name: 'Books').root
    end
  end
end
