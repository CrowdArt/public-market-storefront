source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.0'

gem 'pg'
gem 'pg_query' # used by pghero
gem 'pghero'

gem 'puma', '~> 3.7'

# memcached
gem 'dalli'

gem 'config'
gem 'enumerize'
gem 'phony_rails'

gem 'whenever', require: false

gem 'browser'
gem 'ckeditor'
gem 'coffee-rails', '~> 4.2'
gem 'jbuilder', '~> 2.5'
gem 'sass-rails'
gem 'simple_form'
gem 'slim'
gem 'turbolinks', '~> 5'

gem 'foundation_emails'

gem 'httparty'

gem 'searchkick'

gem 'spree', github: 'spree/spree'
gem 'spree_auth_devise', github: 'abundance-labs/spree_auth_devise'
gem 'spree_batch_api', github: 'abundance-labs/spree_batch_api'
gem 'spree_gateway', github: 'spree/spree_gateway', tag: 'v3.3.3'
gem 'spree_multi_vendor', github: 'abundance-labs/spree_multi_vendor'
gem 'spree_pages'
gem 'spree_searchkick', github: 'abundance-labs/spree_searchkick'
gem 'spree_sitemap', github: 'spree-contrib/spree_sitemap'
gem 'spree_social', github: 'abundance-labs/spree_social'

gem 'delayed_paperclip'
gem 'fog-google'
gem 'sidekiq'

gem 'json_api_client'

gem 'mixpanel-ruby'

gem 'swagger-blocks'

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'elasticsearch-extensions'
  gem 'factory_bot'
  gem 'ffaker'
  gem 'fuubar', require: false
  gem 'rails-controller-testing'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'vcr'
  gem 'webmock'
  gem 'zonebie'
end

group :development do
  gem 'bullet'
  gem 'byebug'
  gem 'guard', require: false
  gem 'guard-rspec', require: false
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-rails'
  gem 'rack-mini-profiler', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'web-console'
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

group :api_db do
  gem 'sqlite3'
end
