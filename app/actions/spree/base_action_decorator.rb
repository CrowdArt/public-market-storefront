module Spree
  module BaseActionDecorator
    private

    def array(array_or_string, separator = ',')
      array_or_string.is_a?(Array) ? array_or_string : array_or_string.to_s.split(separator)
    end
  end

  BaseAction.prepend(BaseActionDecorator)
end
