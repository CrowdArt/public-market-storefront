Spree::Image.class_eval do
  process_in_background :attachment

  def find_dimensions
    temporary = attachment.queued_for_write[:original]
    return if temporary.blank?
    filename = temporary.path unless temporary.nil?
    filename = attachment.path if filename.blank?
    geometry = Paperclip::Geometry.from_file(filename)
    self.attachment_width  = geometry.width
    self.attachment_height = geometry.height
  end

  attachment_definitions[:attachment][:path] = Paperclip::Attachment.default_options[:path]
end
