Paperclip::Attachment.default_options[:path] = [
  Rails.env.development? ? `whoami`.chomp : nil,
  ':class/:id/:style-:basename.:extension'
].compact.join('/')
Paperclip::Attachment.default_options[:url] = ':gcs_domain_url'
Paperclip::Attachment.default_options[:fog_directory] = 'public-market-dev'
