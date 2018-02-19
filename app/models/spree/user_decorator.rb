Spree::User.class_eval do
  validates :first_name, :last_name, presence: true
end
