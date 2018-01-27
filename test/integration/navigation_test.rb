require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  test 'logged out user links' do
    get root_path
    assert_select 'a[href=?]', signup_path
    assert_select 'a[href=?]', login_path
  end

  test 'logged in user links' do
    @user = create(:user)
    log_in_as(@user)
    get root_path
    assert_select 'a[href=?]', root_path
  end
end
