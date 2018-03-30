Spree::Address.class_eval do
  belongs_to :user, class_name: Spree.user_class.to_s, optional: true, inverse_of: :addresses
end
