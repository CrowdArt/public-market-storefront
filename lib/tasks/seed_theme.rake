
require 'rake'

namespace :db do
  desc 'Seed bigshop theme'
  task seed_theme: :environment do
    Spree::Theme.create(template_file: File.new('./db/seeds/themes/default.zip'))
    Spree::Theme.create(state: :published, template_file: File.new('./db/seeds/themes/theme-bigshop.zip'))

    ENV['THEME_NAME'] = 'theme-bigshop'.freeze
    Rake::Task['db:sync_templates'].execute
  end
end
