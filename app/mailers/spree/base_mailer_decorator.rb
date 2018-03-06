Spree::BaseMailer.class_eval do
  protected

  def mail_template(user, template, opts = {})
    @body = I18n.t(['emails', template, 'body'].join('.'), opts)
    subject = I18n.t(['emails', template, 'subject'].join('.'), opts)

    category_header(opts[:category])

    mail(to: user.email,
         subject: subject,
         template_path: 'mailer',
         template_name: 'default')
  end

  def category_header(*categories)
    categories = [Rails.env] | categories
    headers['X-SMTPAPI'] = { category: categories }.to_json
  end
end