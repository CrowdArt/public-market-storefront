desc 'Set missing cost prices'
task set_missing_cost_prices: :environment do
  # Run SQL because rails incorrectly build update_all queries with joins
  query = <<-SQL
    UPDATE spree_variants
    SET cost_price = spree_prices.amount
    FROM spree_prices
    WHERE spree_variants.id = spree_prices.variant_id;
  SQL

  ActiveRecord::Base.connection.execute(query)
end
