require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'capybara/rails'
require 'capybara/minitest'
require 'best_in_place'
require 'best_in_place/test_helpers'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL
  # Make `assert_*` methods behave like Minitest assertions
  include Capybara::Minitest::Assertions
  # Set webkit as default driver
  Capybara.default_driver = :webkit

  include BestInPlace::TestHelpers

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def log_in_as(user)
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password
      }
    }
  end

  def login(user)
    visit login_path
    fill_in('session_email', with: user.email)
    fill_in('session_password', with: user.password)
    click_button('Log in')
  end

  def logout
    page.find("a[href='/logout']").trigger("click")
  end
end
