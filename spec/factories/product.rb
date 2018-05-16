FactoryBot.define do
  factory :book, parent: :product do
    name { FFaker::Book.title }
    taxons { [create(:taxon)] }

    transient do
      author FFaker::Book.author
      isbn FFaker::Book.isbn
      format ['Trade Cloth', 'Trade Paper'].sample
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
    end
  end
end
