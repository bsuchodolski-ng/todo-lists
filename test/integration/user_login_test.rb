require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = create(:user)
  end

  test 'login with invalid data' do
    visit login_path
    fill_in('session_email', with: '')
    fill_in('session_password', with: 'pass')
    within("form[action='#{login_path}']") do
      click_on('Log in')
    end
    assert_selector 'div.alert.alert-danger'
    assert_selector "form[action='#{login_path}']"
  end

  test 'login with valid data and the logout' do
    visit login_path
    fill_in('session_email', with: @user.email)
    fill_in('session_password', with: @user.password)
    within("form[action='#{login_path}']") do
      click_on('Log in')
    end
    page.assert_selector 'div.alert.alert-success'
    page.assert_text "You don't have any to do lists yet."
    assert_selector "a[href='#{logout_path}']"
    page.find("a[href='/logout']").trigger("click")
    page.assert_text "Log in to see your ToDoLists"
    assert_selector 'div.alert.alert-success'
    assert_selector "a[href='#{login_path}']"
  end
end
