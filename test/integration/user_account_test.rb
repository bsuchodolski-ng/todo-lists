require 'test_helper'

class UserAccountTest < ActionDispatch::IntegrationTest

  def setup
    @user = create(:user)
  end

  test 'edit account when not logged in' do
    visit account_path
    page.assert_text 'Log in'
    page.assert_selector '#session_email'
    page.assert_selector '#session_password'
    assert_selector 'div.alert.alert-danger'
  end

  test 'edit account with invalid data' do
    login(@user)
    visit account_path
    assert_selector("form[action='#{account_path}']")
    fill_in('user_email', with: '')
    fill_in('user_password', with: 'pass')
    fill_in('user_password_confirmation', with: 'word')
    click_on('Edit account')
    assert_selector 'div.alert.alert-danger', count: 4
    assert_selector("form[action='#{account_path}']")
  end

  test 'edit account with valid data' do
    login(@user)
    visit account_path
    fill_in('user_email', with: 'user_edited@example.com')
    fill_in('user_password', with: 'password')
    fill_in('user_password_confirmation', with: 'password')
    click_on('Edit account')
    assert_selector 'div.alert.alert-success'
    assert_selector("form[action='#{account_path}']")
    assert @user.email = 'user_edited@example.com'
  end
end
