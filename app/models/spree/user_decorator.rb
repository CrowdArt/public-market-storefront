Spree::User.class_eval do
  has_many :addresses, class_name: 'Spree::Address', dependent: :destroy, inverse_of: :user

  NAME_REGEX = /\A[\p{L}\p{Zs}\x27-]{1,32}\z/

  validates :first_name, :last_name, presence: true, on: %i[edit]
  validates :first_name, :last_name, format: NAME_REGEX, allow_blank: true

  accepts_nested_attributes_for :credit_cards, allow_destroy: true

  before_save :fill_names, if: :ship_address_id_changed?

  after_create :send_welcome_email_with_delay

  after_commit :send_email_change, on: :update, if: :reconfirmation_required?

  def full_name
    [first_name, last_name].join(' ').strip
  end

  def full_name_or_email
    full_name.presence || email
  end

  def username
    first_name.presence || email.split('@').first
  end

  # storefront changes:
  # - remove billing address save
  def persist_order_address(order)
    return unless order.ship_address
    address_attributes = order.ship_address.attributes.except('id', 'updated_at', 'created_at')
    addresses.create(address_attributes)
  end

  def after_confirmation
    # don't send welcome email if:
    # - reconfirmation
    # - welcome email was sent in DelayedWelcomeEmail
    return if previous_changes[:unconfirmed_email] || (confirmation_sent_at.present? && (confirmation_sent_at < 1.hour.ago))
    send_welcome_email
  end

  def active_for_authentication?
    !deleted?
  end

  def default_ship_address
    addresses.order(default: :desc, id: :desc).first
  end

  def default_payment_method
    credit_cards.order(default: :desc, id: :desc).first
  end

  private

  def send_welcome_email_with_delay
    DelayedWelcomeEmail.perform_in(1.hour, id)
  end

  def send_welcome_email
    Spree::UserMailer.welcome(id).deliver_later
  end

  def fill_names
    return if first_name.present? || ship_address.blank?

    self.first_name = ship_address.first_name
    self.last_name = ship_address.last_name
  end

  def scramble_email_and_password
    skip_reconfirmation!
    self.email = 'deleted_' + SecureRandom.uuid.first(5) + email
    self.login = email
    self.password = SecureRandom.hex(8)
    self.password_confirmation = password
    save
  end

  def send_email_change
    Spree::UserMailer.email_change(id).deliver_later
  end
end
