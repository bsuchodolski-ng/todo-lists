require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
end

class ActionDispatch::IntegrationTest

  def log_in_as(user)
    post login_path, params: {
      session: {
        email: user.email,
        password: user.password
      }
    }
  end
end
