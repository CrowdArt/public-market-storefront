require 'selenium/webdriver'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

Capybara.register_driver(:selenium_chrome_headless) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[no-sandbox headless disable-gpu window-size=1024,768] }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.javascript_driver = :selenium_chrome_headless
Capybara.server = :puma, { Silent: true }

module CapybaraHelpers
  def native_fill_field(selector, text)
    text.split('').each { |c| find_field(selector).native.send_keys(c) }
  end
end

RSpec.configure do |config|
  config.include CapybaraHelpers, type: :feature
end
