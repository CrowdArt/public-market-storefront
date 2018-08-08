class AbilityDecorator
  include CanCan::Ability

  def initialize(user)
    persisted_abilities(user) if user.persisted?

    return if user.admin? || user.vendors.blank?
    vendor_abilities
  end

  private

  def persisted_abilities(user)
    can :edit, Spree::Order, user_id: user.id

    can :create, Spree::Address
    can :manage, Spree::Address, user_id: user.id

    can :create, Spree::CreditCard
    can :manage, Spree::CreditCard, user_id: user.id

    can :update, Spree::Orders::VendorView do |view|
      view.vendor.users.include?(user)
    end
  end

  def vendor_abilities
    vendor_shipping_methods_permissions
  end

  def vendor_shipping_methods_permissions
    cannot :manage, Spree::ShippingMethod
  end
end

Spree::Ability.register_ability(AbilityDecorator)
