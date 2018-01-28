require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = create(:user)
  end

  test 'login with invalid data' do
    get login_path
    assert_select 'form[action=?]', login_path
    post login_path, params: {
      session: {
        email: @user.email,
        password: 'wrong_password'
      }
    }
    assert_template 'sessions/new'
    assert_select 'div.alert.alert-danger'
  end

  test 'login with valid data and the logout' do
    get login_path
    assert_select 'form[action=?]', login_path
    post login_path, params: {
      session: {
        email: @user.email,
        password: @user.password
      }
    }
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert.alert-success'
    assert_select 'a[href=?]', logout_path
    delete logout_path
    assert_redirected_to root_path
    follow_redirect!
    assert_select 'div.alert.alert-success'
    assert_select 'a[href=?]', login_path
  end
end
