Spree::User.class_eval do
  include Spree::NormalizeBlankValues

  MIN_LOGIN_LENGTH = 4
  MAX_LOGIN_LENGTH = 25

  extend FriendlyId
  friendly_id :slug_candidates, use: :slugged, slug_column: :login

  has_many :addresses, class_name: 'Spree::Address', dependent: :destroy, inverse_of: :user

  NAME_REGEX = /\A([\p{L}\p{N}\p{Zs}]+[\x27-]*[\p{L}\p{N}\p{Zs}]+){1,32}\z/
  LOGIN_REGEX = /\A[a-z0-9](?:-?[a-z0-9])*\z/

  validates :login, length: { minimum: MIN_LOGIN_LENGTH, maximum: MAX_LOGIN_LENGTH },
                    format: LOGIN_REGEX,
                    uniqueness: true,
                    allow_nil: true

  validates :first_name, :last_name, format: NAME_REGEX, allow_blank: true

  accepts_nested_attributes_for :credit_cards, allow_destroy: true

  before_save :fill_names, if: :ship_address_id_changed?

  after_create :send_welcome_email_with_delay

  # used in login form
  attr_writer :username

  def username
    @username || login || email
  end

  # override to do nothing
  def unset_slug_if_invalid; end

  def set_slug(normalized_slug = nil) # rubocop:disable Metrics/AbcSize
    if send(friendly_id_config.slug_column).present? && send("#{friendly_id_config.slug_column}_changed?")
      # normalize slug before validation if present
      slug = send(friendly_id_config.slug_column)
      normalized_slug = normalize_friendly_id(slug)
      send("#{friendly_id_config.slug_column}=", normalized_slug)
    elsif should_generate_new_friendly_id?
      candidates = FriendlyId::Candidates.new(self, normalized_slug || send(friendly_id_config.base))
      slug = slug_generator.generate(candidates) || resolve_friendly_id_conflict(candidates)
      send "#{friendly_id_config.slug_column}=", slug
    end
  end

  def should_generate_new_friendly_id?
    false
  end

  def slug_candidates
    %i[email_first_part sequence_slug]
  end

  def sequence_slug
    slug = email_first_part.to_param
    sequence = self.class.where("login like '#{slug}-%'").count + 1
    "#{slug}-#{sequence}"
  end

  def full_name
    [first_name, last_name].join(' ').strip
  end

  def full_name_or_email
    full_name.presence || email
  end

  def email_first_part
    email.split('@').first
  end

  def display_name
    first_name.presence || login.presence || email_first_part
  end

  def name_initials
    if first_name.present?
      first_name.first + last_name&.first.to_s
    else
      display_name.first
    end
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

  def self.find_for_database_authentication(warden_conditions)
    conditions = warden_conditions.dup
    login = conditions.delete(:username)
    where(conditions).find_by(['lower(login) = :value OR lower(email) = :value', { value: login.strip.downcase }])
  end

  protected

  # https://github.com/plataformatec/devise/blob/88724e10adaf9ffd1d8dbfbaadda2b9d40de756a/lib/devise/models/confirmable.rb#L254
  def postpone_email_change_until_confirmation_and_regenerate_confirmation_token
    @reconfirmation_required = true
    self.unconfirmed_email = email
    self.confirmed_at = nil
    self.confirmation_token = nil
    Spree::UserMailer.email_change(id, email_was).deliver_later
    generate_confirmation_token
  end

  private

  # override to do nothing
  def set_login; end

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
    self.login = 'deleted_' + login if login.present?
    self.password = SecureRandom.hex(8)
    self.password_confirmation = password
    save
  end

  def check_completed_orders
    true # allow to delete users with orders
  end
end
