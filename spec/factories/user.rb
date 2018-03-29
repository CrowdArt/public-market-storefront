FactoryBot.define do
  factory :pm_user, parent: :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    confirmed_at { Time.current }
    password { FFaker::Internet.password(8, 20) }
  end
end
