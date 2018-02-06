require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'cant update when not logged in' do
    patch account_path, params: {
      user: {
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'cant delete when not logged in' do
    delete account_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end
end
