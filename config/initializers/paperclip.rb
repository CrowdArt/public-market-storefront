require 'google/apis'

Rails.application.configure do
  config.use_paperclip = true

  Google::Apis.logger.level = Logger::INFO unless Rails.env.development?

  Paperclip.options[:log] = false
  Paperclip.options[:content_type_mappings] = {
    aspx: %w[image/jpeg]
  }
end

if Rails.env.development?
  path_prefix = `whoami`.chomp
  path = ':class/:id/:style-:basename.:extension'
  Paperclip::Attachment.default_options[:path] = [path_prefix, path].compact.join('/')
end
