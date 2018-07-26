module Spree
  module Stock
    Package.class_eval do
      def add(inventory_unit, state = :on_hand)
        Array.new(inventory_unit.quantity).each do
          unit = InventoryUnit.split(inventory_unit, 1)
          contents << ContentItem.new(unit, state)
        end
      end
    end
  end
end
