FactoryBot.define do
  factory :stripe_card_payment_method, class: Spree::Gateway::StripeGateway do
    name 'Stripe'
    preferred_secret_key { Settings.stripe_sk_key }
    preferred_publishable_key { Settings.stripe_pk_key }
  end
end
