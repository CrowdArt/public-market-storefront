desc 'Categorise books'
task categorise_books: :environment do
  products = Spree::Product.includes(:properties).joins(:properties).where(spree_properties: { name: 'isbn' })

  products.select(:id).find_in_batches do |prods|
    args = prods.map { |obj| [obj.id] }
    Sidekiq::Client.push_bulk('class' => Spree::BooksClassifierWorker, 'args' => args)
  end
end
