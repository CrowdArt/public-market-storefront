Spree::Gateway::StripeGateway.create!(
  name: 'Credit Card',
  description: 'Pay by Stripe',
  active: true,
  display_on: 'both',
  preferences: {
    secret_key: Settings.stripe_secret_key,
    publishable_key: Settings.stripe_publishable_key,
    test_mode: true
  }
)
