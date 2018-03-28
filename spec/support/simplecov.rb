require 'simplecov'

SimpleCov.start(:rails) do
  add_filter('app/models/ckeditor/asset.rb')
  add_filter('app/models/ckeditor/attachment_file.rb')
  add_filter('app/models/ckeditor/picture.rb')
  add_filter('lib/mailer_previews')
end
