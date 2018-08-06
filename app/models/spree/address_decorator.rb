Spree::Address.class_eval do
  acts_as_paranoid

  belongs_to :user, class_name: Spree.user_class.to_s, optional: true, inverse_of: :addresses

  phony_normalize :phone, default_country_code: 'US'
  validates :phone, phony_plausible: true

  after_save :ensure_one_default

  EXCLUDED_KEYS_FOR_COMPARISION = %w[id user_id updated_at created_at].freeze

  def same_as?(other)
    return false if other.nil?
    attributes.except(*EXCLUDED_KEYS_FOR_COMPARISION) == other.attributes.except(*EXCLUDED_KEYS_FOR_COMPARISION)
  end

  def full_address
    [address1, city, "#{state.abbr} #{zipcode}", country].join(', ')
  end

  private

  def ensure_one_default
    return if user_id.blank? || !default

    Spree::Address.where(default: true, user_id: user_id)
                  .where.not(id: id)
                  .update_all(default: false) # rubocop:disable Rails/SkipsModelValidations
  end
end
