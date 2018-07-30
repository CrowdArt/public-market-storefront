Spree::User.skip_callback(:create, :after, :send_welcome_email_with_delay)

default_path = File.join(File.dirname(__FILE__), 'default')

Rake::Task['db:load_dir'].reenable
Rake::Task['db:load_dir'].invoke(default_path)