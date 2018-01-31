# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative 'config/application'

Rails.application.load_tasks

namespace :spree_sample do
  desc 'Loads sample bookstore data'
  task book_samples: :environment do
    require './db/samples.rb'
  end

  desc 'Loads Indaba inventory sample'
  task indaba_samples: :environment do
    Spree::Inventory::UploadFileAction.call('csv', File.read('./db/samples/inventory.csv'))
  end
end
