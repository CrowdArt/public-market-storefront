Spree::CreditCard.class_eval do
  belongs_to :address, class_name: 'Spree::Address', required: true # rubocop:disable Rails/InverseOf
  accepts_nested_attributes_for :address

  before_validation :clone_shipping_address, if: :use_shipping?
  attr_accessor :use_shipping

  private

  def use_shipping?
    use_shipping.in?([true, 'true', '1'])
  end

  def clone_shipping_address
    return if user.shipping_address.blank?
    self.address = user.shipping_address.clone
  end
end
