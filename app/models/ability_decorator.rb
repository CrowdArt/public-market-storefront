class AbilityDecorator
  include CanCan::Ability

  def initialize(user)
    can :rate, Spree::Order, user_id: user.id
  end
end

Spree::Ability.register_ability(AbilityDecorator)
