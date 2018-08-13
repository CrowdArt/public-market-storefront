module Spree
  module PaymentHelper
    def payment_method_dropdown_item(card)
      [card.name_with_initial, card.cc_type&.humanize, card.display_number(show_prefix: :short)].join(' ')
    end

    def card_name_type(card)
      [card.card_name.presence || card.cc_type&.humanize&.upcase, card.display_number].join(' ')
    end
  end
end
