require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  test 'logged out user links' do
    visit root_path
    page.assert_selector("a[href='#{signup_path}']")
    page.assert_selector("a[href='#{login_path}']")
  end

  test 'loggin in user links' do
    @user = create(:user)
    login(@user)
    visit root_path
    page.assert_selector("a[href='#{root_path}']")
    page.assert_selector("a[href='#{logout_path}']")
  end
end
