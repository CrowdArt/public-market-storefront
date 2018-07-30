FactoryBot.modify do
  factory :credit_card do
    address
    user
    slug { SecureRandom.uuid.first(5) }
    gateway_payment_profile_id 'tok_visa'
    cc_type 'visa'
  end
end
