module Spree
  module PaymentHelper
    def payment_method_dropdown_item(card)
      [card.name_with_initial, card.cc_type&.humanize, card.display_number(show_prefix: :short)].join(' ')
    end
  end
end
