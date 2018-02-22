Spree::User.class_eval do
  NAME_REGEX = /\A[\p{L}\p{Zs}\x27-]{1,32}\z/

  validates :first_name, :last_name, presence: true, on: %i[signup edit]
  validates :first_name, :last_name, format: NAME_REGEX, allow_blank: true

  validates :email, confirmation: true

  accepts_nested_attributes_for :credit_cards, allow_destroy: true

  def full_name
    [first_name, last_name].join(' ').strip
  end

  def full_name_or_email
    full_name.presence || email
  end
end
