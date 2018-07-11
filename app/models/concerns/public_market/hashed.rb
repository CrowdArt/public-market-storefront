module PublicMarket
  module Hashed
    extend ActiveSupport::Concern

    def hash_id
      self.class.encoded_id(id)
    end

    module ClassMethods
      def find_by_hash_id(hash_id)
        find_by(id: decoded_id(hash_id))
      end

      def encoded_id(id)
        hashids.encode(id)
      end

      def decoded_id(hash_id)
        hashids.decode(hash_id).first
      end

      private

      def hashids
        Hashids.new('salt for hashed', 5, '123456789cfhistuCFHISTU')
      end
    end
  end
end
