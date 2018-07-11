FactoryBot.define do
  factory :book, parent: :product do
    name { FFaker::Book.title }
    taxons { [Spree::Taxonomy.first_or_create(name: 'Books').root] }

    transient do
      author FFaker::Book.author
      isbn FFaker::Book.isbn
      format ['Trade Cloth', 'Trade Paper'].sample
      edition nil
    end

    trait :with_variant do
      variants { create_list(:variant, 1, price: price) }
    end

    after :create do |product, evaluator|
      create(:product_property,
             product: product,
             property: create(:property, name: 'author'),
             value: evaluator.author)

      create(:product_property,
             product: product,
             property: create(:property, name: 'isbn'),
             value: evaluator.isbn)

      create(:product_property,
             product: product,
             property: create(:property, name: 'format'),
             value: evaluator.format)

      if evaluator.edition.present?
        create(:product_property,
               product: product,
               property: create(:property, name: 'edition'),
               value: evaluator.edition)
      end
    end
  end
end
