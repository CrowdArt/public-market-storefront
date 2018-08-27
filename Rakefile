# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

Rake::Task[:default].clear

task default: :environment do
  Rake::Task['parallel:spec'].invoke('4')
end

namespace :spree_sample do
  desc 'Loads sample storefront data'
  task book_samples: :environment do
    require './db/samples.rb'
  end

  desc 'Loads Indaba inventory sample'
  task indaba_samples: :environment do
    require 'sidekiq/testing'
    Sidekiq::Testing.inline!
    Spree::Inventory::UploadFileAction.call(format: 'csv', file_path: './db/samples/inventory.csv', vendor_id: Spree::Vendor.first.id)
    Spree::Product.reindex
  end

  desc 'Loads music inventory sample'
  task music_samples: :environment do
    require 'sidekiq/testing'
    Sidekiq::Testing.inline!

    Spree::Inventory::UploadFileAction.call(
      format: 'json',
      file_path: './db/samples/music.json',
      product_type: 'music',
      vendor_id: Spree::Vendor.last.id
    )

    Spree::Product.reindex
  end
end

namespace :db do
  desc 'Seed bisac taxonomy'
  task seed_bisac: :environment do
    require './db/seeds/bisac.rb'
  end

  desc 'Seed social authentication methods'
  task seed_social_auth: :environment do
    require './db/default/social_auth.rb'
  end

  desc 'Create sample db'
  task :sample do
    system('rake db:drop')
    system('rake db:create')
    system('rake db:migrate')
    system('rake db:setup')
    system('rake spree_sample:indaba_samples')
  end

  desc 'Seed music taxonomy'
  task seed_music: :environment do
    require './db/seeds/music_taxonomy.rb'
  end
end
