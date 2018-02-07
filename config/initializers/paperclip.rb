if Rails.env.development?
  path_prefix = `whoami`.chomp
  path = ':class/:id/:style-:basename.:extension'

  Paperclip::Attachment.default_options[:path] = [path_prefix, path].compact.join('/')

  Paperclip::Attachment.default_options[:url] = ':gcs_domain_url'
  Paperclip::Attachment.default_options[:fog_directory] = 'public-market-dev'
end
