Spree::BaseMailer.class_eval do
  protected

  def mail_template(resource, template, opts = {})
    @body = I18n.t(['emails', template, 'body'].join('.'), opts)
    @preview = I18n.t(['emails', template, 'preview'].join('.'), opts)
    @footer = I18n.t(['emails', template, 'footer'].join('.'), opts)
    subject = I18n.t(['emails', template, 'subject'].join('.'), opts)

    category_header(opts[:category])

    mail(to: resource.email,
         subject: subject,
         template_path: 'mailer',
         template_name: 'default')
  end

  def category_header(*categories)
    categories = [Rails.env] | categories
    headers['X-SMTPAPI'] = { category: categories }.to_json
  end
end
