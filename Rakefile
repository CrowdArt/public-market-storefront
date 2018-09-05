# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

Rake::Task[:default].clear

task default: :environment do
  Rake::Task['parallel:spec'].invoke('4')
end

namespace :jobs do
  desc 'Run sidekiq uploads'
  task sidekiq_uploads: :environment do
    q = Spree::Vendor.pluck(:slug).map { |s| "-q #{s}-uploads, 1" }
    p 'Run queues: ', q
    system("sidekiq -c 25 -C '' #{q.join(' ')}")
  end
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

  desc 'Allow to add unique index on variants'
  task fill_sku: :environment do
    # fill skus with ISBN
    p Spree::Variant.connection.execute <<-SQL
      UPDATE "spree_variants"
      SET sku = value
      FROM "spree_products"
      INNER JOIN "spree_product_properties" ON "spree_product_properties"."product_id" = "spree_products"."id"
      INNER JOIN "spree_properties" ON "spree_properties"."id" = "spree_product_properties"."property_id"
      WHERE "spree_products"."id" = "spree_variants"."product_id" and
            "spree_properties"."name" = 'isbn' and
            "spree_product_properties"."property_id" = 1 and is_master = true and sku = ''
    SQL

    # fill music skus with variant skus
    p Spree::Variant.connection.execute <<-SQL
      UPDATE "spree_variants"
      SET sku = 'MSC-' || v.vendor_id || '-' || v.sku
      FROM "spree_products"
      INNER JOIN "spree_variants" as v ON v."product_id" = "spree_products"."id" and v.is_master = false
      WHERE "spree_products"."id" = "spree_variants"."product_id" and
            "spree_variants".is_master = true and "spree_variants".sku = ''
    SQL
  end

  desc 'Remove dublicate products'
  task remove_dublicates: :environment do
    Spree::ProductProperty.joins(:product).where(property_id: 1).group(:value).having('count(value) > 1').reorder('').pluck('min(slug), array_agg(spree_products.id)').each do |a|
      correct_product = Spree::Product.find_by(slug: a.first)
      products_to_delete = a.last - [correct_product.id]

      Spree::Variant.unscoped.where(product_id: products_to_delete, is_master: false).update_all(product_id: correct_product.id)
      Spree::Product.where(id: products_to_delete).each(&:really_destroy!)
    end
  end
end
