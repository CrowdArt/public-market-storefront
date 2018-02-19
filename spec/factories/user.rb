FactoryBot.define do
  factory :bookstore_user, parent: :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
  end
end
