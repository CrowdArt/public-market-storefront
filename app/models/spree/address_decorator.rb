Spree::Address.class_eval do
  belongs_to :user, class_name: Spree.user_class.to_s, optional: true, inverse_of: :addresses

  EXCLUDED_KEYS_FOR_COMPARISION = %w[id user_id updated_at created_at].freeze

  def same_as?(other)
    return false if other.nil?
    attributes.except(*EXCLUDED_KEYS_FOR_COMPARISION) == other.attributes.except(*EXCLUDED_KEYS_FOR_COMPARISION)
  end
end
