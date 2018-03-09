Spree::User.class_eval do
  NAME_REGEX = /\A[\p{L}\p{Zs}\x27-]{1,32}\z/

  validates :first_name, :last_name, presence: true, on: %i[edit]
  validates :first_name, :last_name, format: NAME_REGEX, allow_blank: true

  accepts_nested_attributes_for :credit_cards, allow_destroy: true

  before_save :fill_names, if: :ship_address_id_changed?
  after_create :send_welcome_email

  def full_name
    [first_name, last_name].join(' ').strip
  end

  def full_name_or_email
    full_name.presence || email
  end

  private

  def send_welcome_email
    Spree::UserMailer.welcome(id).deliver_later
  end

  def fill_names
    return if first_name.present? || ship_address.blank?

    self.first_name = ship_address.first_name
    self.last_name = ship_address.last_name
  end
end
