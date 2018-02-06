require 'test_helper'

class UserAccountTest < ActionDispatch::IntegrationTest

  def setup
    @user = create(:user)
  end

  test 'edit account when not logged in' do
    get account_path
    assert_redirected_to login_path
    follow_redirect!
    assert_select 'div.alert.alert-danger'
  end

  test 'edit account with invalid data' do
    log_in_as(@user)
    get account_path
    assert_select 'form[action=?]', account_path
    patch account_path, params: {
      user: {
        email: "",
        password: "pass",
        password_confirmation: "word"
      }
    }
    assert_template 'users/edit'
    assert_select 'div.alert.alert-danger', count: 4
  end

  test 'edit account with valid data' do
    log_in_as(@user)
    get account_path
    patch account_path, params: {
      user: {
        email: 'user@example2.com',
        password: 'password2',
        password_confirmation: 'password2'
      }
    }
    follow_redirect!
    assert_template 'edit'
    assert_select 'div.alert.alert-success'
    assert @user.email = 'user@example2.com'
  end
end
