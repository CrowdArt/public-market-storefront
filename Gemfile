source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'

gem 'pg', '0.21.0'
gem 'pg_query' # used by pghero
gem 'pghero'

gem 'puma', '~> 3.7'

gem 'sass-rails'

gem 'config'

gem 'bootswatch-rails'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
# gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'spree', github: 'spree/spree'
gem 'spree_auth_devise', '~> 3.3'
gem 'spree_gateway', '~> 3.3'
gem 'spree_reviews', github: 'public-market/spree_reviews'
gem 'spree_social', github: 'public-market/spree_social'
# gem 'vinsol_spree_themes', github: 'vinsol-spree-contrib/spree_themes', branch: 'master'

gem 'spree_batch_api', github: 'public-market/spree_batch_api'
gem 'spree_multi_vendor', github: 'public-market/spree_multi_vendor'
# gem 'spree_batch_api', path: '../spree_batch_api'
# gem 'spree_multi_vendor', path: '../spree_multi_vendor'

gem 'delayed_paperclip'
gem 'fog-google'
gem 'sidekiq'

group :test do
  gem 'capybara', '~> 2.13'
  gem 'rspec'
  gem 'rspec-rails'
  gem 'selenium-webdriver'
end

group :development do
  gem 'byebug'
  gem 'guard'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'rack-mini-profiler', require: false
  gem 'rubocop', require: false
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console', '>= 3.3.0'
end

group :production, :staging do
  gem 'therubyracer'
  gem 'uglifier'
end
