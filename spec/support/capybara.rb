require 'selenium/webdriver'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara-screenshot/rspec'

Capybara.register_driver(:selenium_chrome_headless) do |app|
  capabilities = Selenium::WebDriver::Remote::Capabilities.chrome(
    chromeOptions: { args: %w[headless disable-gpu] }
  )

  Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: capabilities)
end

Capybara.javascript_driver = :selenium_chrome_headless
