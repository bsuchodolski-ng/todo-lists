require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test 'sign up with invalid data' do
    get signup_path
    assert_select 'form[action=?]', signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: {
        user: {
          email: "",
          password: "pass",
          password_confirmation: "word"
        }
      }
    end
    assert_template 'users/new'
    assert_select 'div.alert.alert-danger', count: 4
  end

  test 'sign up with valid data' do
    get signup_path
    assert_difference 'User.count', 1 do
      post signup_path, params: {
        user: {
          email: 'user@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    follow_redirect!
    assert_template 'to_do_lists/index'
    assert_select 'div.alert.alert-success'
  end
end
