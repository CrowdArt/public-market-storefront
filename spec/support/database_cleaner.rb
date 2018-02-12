
RSpec.configure do |config|
  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each, type: ->(v) { v != :feature }) do |example|
    DatabaseCleaner.strategy = :transaction
    example.run
  end

  config.around(:each, type: :feature) do |example|
    DatabaseCleaner.strategy = :truncation
    example.run
  end

  config.around do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end
end
