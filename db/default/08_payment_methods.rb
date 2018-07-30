Spree::Gateway::StripeGateway.create!(
  name: 'Credit Card',
  description: 'Pay by Stripe',
  active: true,
  display_on: 'both',
  preferences: {
    secret_key: Rails.application.credentials.stripe_secret_key,
    publishable_key: Rails.application.credentials.stripe_publishable_key,
    test_mode: true
  }
)
