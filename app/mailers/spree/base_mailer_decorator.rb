Spree::BaseMailer.class_eval do
  protected

  def mail_template(resource, template, opts = {})
    @body = I18n.t(['emails', template, 'body'].join('.'), opts)
    @preview = I18n.t(['emails', template, 'preview'].join('.'), opts)
    @footer = I18n.t(['emails', template, 'footer'].join('.'), opts, default: nil)
    subject = I18n.t(['emails', template, 'subject'].join('.'), opts)

    set_smtp_headers(template)

    mail(to: resource.email,
         subject: subject,
         template_path: 'mailer',
         template_name: 'default')
  end

  def set_smtp_headers(template)
    sendgrid_categories = I18n.t(['emails', template, 'categories'].join('.')) || [template]
    categories = [Rails.env] | sendgrid_categories

    smtp_headers = {
      category: categories,
      sub: {
        '%rawUnsubscribe%': ['<%asm_group_unsubscribe_raw_url%>'],
        '%rawPreferences%': ['<%asm_preferences_raw_url%>']
      }
    }

    if (unsub_category = unsubscribe_category(sendgrid_categories))
      smtp_headers[:asm_group_id] = unsub_category
    end

    headers['X-SMTPAPI'] = smtp_headers.to_json
  end

  def unsubscribe_category(categories)
    category = categories.detect { |c| Settings["sendgrid-unsubscribe-#{c}"].presence }
    Settings["sendgrid-unsubscribe-#{category}"]
  end

  def line_items_as_text(items)
    first_item = items[0]
    line = "#{first_item.quantity}x \"#{first_item.variant.product.name}\""

    return line if items.length == 1
    more_items_count = items.length - 1
    line + "... and #{more_items_count} other #{'item'.pluralize(more_items_count)}"
  end
end
