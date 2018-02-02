Spree::Gateway::StripeGateway.where(
  name: 'Stripe',
  description: 'Pay by Stripe',
  active: true
).first_or_create!
