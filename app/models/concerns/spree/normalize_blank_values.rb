module Spree
  module NormalizeBlankValues
    extend ActiveSupport::Concern

    included do
      before_validation :normalize_blank_values
    end

    def normalize_blank_values
      attributes.each do |column, _value|
        self[column].present? || self[column] = nil
      end
    end
  end
end
