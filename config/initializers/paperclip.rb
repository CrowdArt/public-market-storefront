Paperclip::Attachment.default_options[:path] = '/:class/:attachment/:id_partition/:style/:filename'
Paperclip::Attachment.default_options[:url] = ':gcs_domain_url'
Paperclip::Attachment.default_options[:fog_directory] = 'public-market-dev'
