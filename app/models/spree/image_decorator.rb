Spree::Image.class_eval do
  process_in_background :attachment
end
