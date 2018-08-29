source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '5.2.0'

gem 'rails-env-credentials', github: 'public-market/rails-env-credentials'

gem 'pg'
gem 'pg_query' # used by pghero
gem 'pghero'

gem 'puma', '~> 3.7'

# memcached
gem 'dalli'

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

gem 'hashids'
gem 'httparty'

gem 'oj'
gem 'searchkick'
gem 'typhoeus'

gem 'spree', github: 'spree/spree'
gem 'spree_auth_devise', github: 'public-market/spree_auth_devise'
gem 'spree_batch_api', github: 'public-market/spree_batch_api'
gem 'spree_gateway', github: 'spree/spree_gateway', tag: 'v3.3.3'
gem 'spree_multi_vendor', github: 'public-market/spree_multi_vendor'
gem 'spree_pages'
gem 'spree_searchkick', github: 'public-market/spree_searchkick'
gem 'spree_sitemap', github: 'spree-contrib/spree_sitemap'
gem 'spree_social', github: 'public-market/spree_social'

gem 'delayed_paperclip'
gem 'fog-google'
gem 'google-cloud-storage', '~> 1.8', require: false
gem 'sidekiq'
gem 'sidekiq-scheduler'

gem 'json_api_client'

gem 'mixpanel-ruby'

gem 'swagger-blocks'

gem 'slack-notifier'

group :test do
  gem 'capybara'
  gem 'capybara-screenshot'
  gem 'chromedriver-helper'
  gem 'database_cleaner'
  gem 'elasticsearch-extensions'
  gem 'factory_bot', '~> 4.10.0' # https://github.com/spree/spree/pull/8955
  gem 'ffaker'
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
  gem 'listen', require: false
  gem 'pry-rails'
  gem 'rack-mini-profiler', require: false
  gem 'spring', require: false
  gem 'spring-watcher-listen', require: false
  gem 'web-console'
end

group :test, :development do
  gem 'parallel_tests'
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
