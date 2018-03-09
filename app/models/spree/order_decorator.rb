Spree::Order.class_eval do
  before_validation :clone_shipping_address, if: :use_shipping?
  attr_accessor :use_shipping

  private

  def use_shipping?
    use_shipping.in?([true, 'true', '1'])
  end

  def clone_shipping_address
    if ship_address && bill_address.nil?
      self.bill_address = ship_address.clone
    else
      bill_address.attributes = ship_address.attributes.except('id', 'updated_at', 'created_at')
    end
    true
  end
end
