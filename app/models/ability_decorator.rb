class AbilityDecorator
  include CanCan::Ability

  def initialize(user)
    can :rate, Spree::Order, user_id: user.id

    can :manage, Spree::Address, user_id: user.id

    can :create, Spree::Address do
      user.id.present?
    end
  end
end

Spree::Ability.register_ability(AbilityDecorator)
