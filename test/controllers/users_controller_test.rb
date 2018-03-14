require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
  end

  test 'should get new' do
    get signup_path
    assert_response :success
  end

  test 'should create user' do
    assert_difference 'User.count', 1 do
      post signup_path, params: {
        user: {
          email: 'user@example.com',
          password: 'password',
          password_confirmation: 'password'
        }
      }
    end
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test 'edit should redirect to login if not logged in' do
    get account_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should get edit if logged in' do
    log_in_as(@user)
    get account_path
    assert_response :success
  end

  test 'update should redirect to login if not logged in' do
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

  test 'update is possible for logged in user' do
    log_in_as(@user)
    patch account_path, params: {
      user: {
        email: 'user@example.com',
        password: 'password',
        password_confirmation: 'password'
      }
    }
    assert_not flash.empty?
    assert @user.reload.email == 'user@example.com'
  end

  test 'destroy should redirect to login' do
    delete account_path
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should destroy user if user is logged in' do
    log_in_as(@user)
    assert_difference 'User.count', -1 do
      delete account_path
    end
  end
end
