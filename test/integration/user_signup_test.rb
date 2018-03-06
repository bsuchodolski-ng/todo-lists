require 'test_helper'

class UserSignupTest < ActionDispatch::IntegrationTest

  test 'sign up with invalid data' do
    visit signup_path
    page.assert_selector("form[action='#{signup_path}']")
    assert_no_difference 'User.count' do
      fill_in('user_email', with: '')
      fill_in('user_password', with: 'pass')
      fill_in('user_password_confirmation', with: 'word')
      click_on('Create account')
    end
    page.assert_selector 'div.alert.alert-danger', count: 4
  end

  test 'sign up with valid data' do
    visit signup_path
    page.assert_selector("form[action='#{signup_path}']")
    assert_difference 'User.count', 1 do
      fill_in('user_email', with: 'user@example.com')
      fill_in('user_password', with: 'password')
      fill_in('user_password_confirmation', with: 'password')
      click_on('Create account')
      page.assert_selector 'div.alert.alert-success'
    end
    page.assert_text "You don't have any to do lists yet."
  end

end
