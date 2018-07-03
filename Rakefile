# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :spree_sample do
  desc 'Loads sample storefront data'
  task book_samples: :environment do
    require './db/samples.rb'
  end

  desc 'Loads Indaba inventory sample'
  task indaba_samples: :environment do
    require 'sidekiq/testing'
    Sidekiq::Testing.inline!
    Spree::Inventory::UploadFileAction.call('csv',
                                            './db/samples/inventory.csv', upload_options: {
                                              vendor: Spree::Vendor.last
                                            })
    Spree::Product.reindex
  end

  desc 'Loads music inventory sample'
  task music_samples: :environment do
    require 'sidekiq/testing'
    Sidekiq::Testing.inline!
    Spree::Inventory::UploadFileAction.call(
      'json',
      './db/samples/music.json',
      product_type: 'music',
      upload_options: {
        vendor: Spree::Vendor.last
      }
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
