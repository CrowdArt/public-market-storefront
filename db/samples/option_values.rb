require_relative 'option_types'

condition = Spree::OptionType.find_by!(name: 'condition')

conditions = [
  {
    name: 'new',
    presentation: 'New'
  },
  {
    name: 'refurbished',
    presentation: 'Refurbished'
  },
  {
    name: 'used_like_new',
    presentation: 'Used – Like New'
  },
  {
    name: 'used_very_good',
    presentation: 'Used – Very Good'
  },
  {
    name: 'used_good',
    presentation: 'Used – Good'
  },
  {
    name: 'used_acceptable',
    presentation: 'Used – Acceptable'
  }
]

conditions.each do |cond|
  Spree::OptionValue.where(**cond, option_type: condition).first_or_create
end
