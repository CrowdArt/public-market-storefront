class AbilityDecorator
  include CanCan::Ability

  def initialize(user)
    persisted_abilities(user) if user.persisted?
  end

  private

  def persisted_abilities(user)
    can :rate, Spree::Order, user_id: user.id

    can :create, Spree::Address
    can :manage, Spree::Address, user_id: user.id

    can :create, Spree::CreditCard
    can :manage, Spree::CreditCard, user_id: user.id

    can :update, Spree::Orders::VendorView do |view|
      view.vendor.users.include?(user)
    end
  end
end

Spree::Ability.register_ability(AbilityDecorator)
