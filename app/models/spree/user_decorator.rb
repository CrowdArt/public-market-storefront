Spree::User.class_eval do
  NAME_REGEX = /\A[\p{L}\p{N}\p{Zs}\x27-]{1,32}\z/

  validates :first_name, :last_name, presence: true, format: NAME_REGEX
end
