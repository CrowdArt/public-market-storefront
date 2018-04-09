class DelayedWelcomeEmail
  include Sidekiq::Worker

  sidekiq_options queue: 'mailers', unique: :until_executed

  def perform(user_id)
    user = Spree::User.find_by(id: user_id)

    return if user.confirmed?

    Spree::UserMailer.welcome(user_id).deliver_later
  end
end
