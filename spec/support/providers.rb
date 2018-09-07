RSpec.configure do |config|
  config.before do
    allow_any_instance_of('Spree::Inventory::Providers::Books::BowkerMetadataProvider'.constantize).to receive(:images).and_return([])

    %w[Music Generic].each do |type|
      allow_any_instance_of("Spree::Inventory::Providers::#{type}::MetadataProvider".constantize).to receive(:images).and_return([])
    end
  end

  config.before(:each, images: true) do
    allow_any_instance_of('Spree::Inventory::Providers::Books::BowkerMetadataProvider'.constantize).to receive(:images).and_call_original

    %w[Music Generic].each do |type|
      allow_any_instance_of("Spree::Inventory::Providers::#{type}::MetadataProvider".constantize).to receive(:images).and_call_original
    end
  end
end
