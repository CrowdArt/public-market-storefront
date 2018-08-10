FactoryBot.modify do
  factory :vendor do
    before(:create) do
      # create shipping zone before shipping method creation
      Spree::Zone.global if Spree::Zone.none?
    end
  end
end
