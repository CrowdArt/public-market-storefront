module ErrorsHelper
  # allows to use ^ in error messages to exclude field name
  def customize_error_message(target, attr, msg)
    if attr == :base
      msg
    elsif msg[0] == '^'
      msg[1..-1]
    else
      "#{target.class.human_attribute_name(attr)} #{msg}"
    end
  end
end
