module Ckeditor
  class Asset < ActiveRecord::Base # rubocop:disable Rails/ApplicationRecord
    include Ckeditor::Orm::ActiveRecord::AssetBase
    include Ckeditor::Backend::Paperclip
  end
end
