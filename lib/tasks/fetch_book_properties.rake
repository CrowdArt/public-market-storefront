desc 'Fetch book properties'
task fetch_book_properties: :environment do
  products = Spree::Product.unscoped.joins(:properties).where(spree_properties: { name: 'isbn' })

  products.select(:id).find_in_batches do |prods|
    args = prods.map { |obj| [obj.id] }
    Sidekiq::Client.push_bulk('class' => Spree::BookPropertiesFetcher, 'args' => args)
  end
end
