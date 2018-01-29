option_types_attributes = [
  {
    name: 'condition',
    presentation: 'Condition'
  }
]

option_types_attributes.each do |attrs|
  Spree::OptionType.where(attrs).first_or_create!
end
