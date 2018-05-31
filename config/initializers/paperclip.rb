Rails.application.configure do
  config.use_paperclip = true
end

Paperclip.options[:content_type_mappings] = {
  aspx: %w[image/jpeg]
}

if Rails.env.development?
  path_prefix = `whoami`.chomp
  path = ':class/:id/:style-:basename.:extension'
  Paperclip::Attachment.default_options[:path] = [path_prefix, path].compact.join('/')
end
