Paperclip.options[:content_type_mappings] = {
  aspx: %w[image/jpeg]
}

if Rails.env.development?
  path_prefix = `whoami`.chomp
  path = ':class/:id/:style-:basename.:extension'
  Paperclip::Attachment.default_options[:path] = [path_prefix, path].compact.join('/')
end
