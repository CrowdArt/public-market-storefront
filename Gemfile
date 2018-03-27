source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.1.5'

gem 'pg', '0.21.0'
gem 'pg_query' # used by pghero
gem 'pghero'

gem 'puma', '~> 3.7'

# memcached
gem 'dalli'

gem 'config'

gem 'bootswatch-rails'

gem 'ckeditor'
gem 'cocoon'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'sass-rails'
gem 'slim'
gem 'turbolinks', '~> 5'

gem 'foundation_emails'

gem 'httparty'

gem 'searchkick'

gem 'spree', github: 'spree/spree'
gem 'spree_auth_devise', github: 'public-market/spree_auth_devise'
gem 'spree_batch_api', github: 'public-market/spree_batch_api'
gem 'spree_gateway', '~> 3.3'
gem 'spree_multi_vendor', github: 'public-market/spree_multi_vendor'
gem 'spree_pages', github: 'public-market/spree_pages'
# gem 'spree_reviews', github: 'public-market/spree_reviews'
gem 'spree_searchkick', github: 'public-market/spree_searchkick'
gem 'spree_social', github: 'public-market/spree_social'

gem 'delayed_paperclip'
gem 'fog-google'
gem 'sidekiq'

gem 'swagger-blocks'

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'elasticsearch-extensions'
  gem 'factory_bot'
  gem 'ffaker'
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
end

group :development do
  gem 'bullet'
  gem 'byebug'
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console', '>= 3.3.0'
end

group :test, :development do
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

group :production, :staging do
  gem 'rack-attack'
  gem 'sentry-raven'
  gem 'therubyracer'
  gem 'uglifier'
end
