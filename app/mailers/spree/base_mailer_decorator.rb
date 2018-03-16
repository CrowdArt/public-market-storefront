Spree::BaseMailer.class_eval do
  protected

  def mail_template(resource, template, opts = {})
    @body = I18n.t(['emails', template, 'body'].join('.'), opts)
    @preview = I18n.t(['emails', template, 'preview'].join('.'), opts)
    @footer = I18n.t(['emails', template, 'footer'].join('.'), opts, default: nil)
    subject = I18n.t(['emails', template, 'subject'].join('.'), opts)

    category_header(opts[:category] || template)

    mail(to: resource.email,
         subject: subject,
         template_path: 'mailer',
         template_name: 'default')
  end

  def category_header(*categories)
    categories = [Rails.env] | categories
    headers['X-SMTPAPI'] = { category: categories }.to_json
  end

  def line_items_as_text(items)
    first_item = items[0]
    line = "#{first_item.quantity}x #{first_item.variant.product.name}"

    return line if items.length == 1
    more_items_count = items.length - 1
    line + "... and #{more_items_count} other #{'item'.pluralize(more_items_count)}"
  end
end
