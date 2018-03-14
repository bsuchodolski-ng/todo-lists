require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
  end

  test 'should get new' do
    get login_path
    assert_response :success
  end

  test 'create should log user in if credentials are valid' do
    post login_path, params: {
      session: {
        email: @user.email,
        password: @user.password
      }
    }
    assert session[:user_id] == @user.id
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test 'create should not log user in if credentials are not valid' do
    post login_path, params: {
      session: {
        email: @user.email,
        password: 'random_string'
      }
    }
    assert session[:user_id].nil?
    assert_not flash.empty?
  end

  test 'destroy should log user out if user is logged in' do
    log_in_as(@user)
    delete logout_path
    assert session[:user_id].nil?
    assert_not flash.empty?
    assert_redirected_to root_path
  end

  test 'destroy should redirect to root path if not logged in' do
    delete logout_path
    assert session[:user_id].nil?
    assert_not flash.empty?
    assert_redirected_to root_path
  end

end
