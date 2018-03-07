Spree::CheckoutController.class_eval do
  # storefront changes:
  # - payment_sources changed to credit_cards
  def before_payment
    if @order.checkout_steps.include? 'delivery'
      packages = @order.shipments.map(&:to_package)
      @differentiator = Spree::Stock::Differentiator.new(@order, packages)
      @differentiator.missing.each do |variant, quantity|
        @order.contents.remove(variant, quantity)
      end
    end

    @payment_sources = try_spree_current_user.credit_cards if try_spree_current_user&.respond_to?(:credit_cards)
  end
end
