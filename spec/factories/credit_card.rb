FactoryBot.modify do
  factory :credit_card do
    address
    user
    slug { SecureRandom.uuid.first(5) }
  end
end
