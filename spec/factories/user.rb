FactoryBot.modify do
  factory :user do
    first_name { FFaker::Name.first_name }
    last_name { FFaker::Name.last_name }
    confirmed_at { Time.current }
    password { FFaker::Internet.password(8, 20) }
    login nil
  end
end
