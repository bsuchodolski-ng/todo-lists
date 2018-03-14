require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
    @to_do_list = create(:to_do_list, user: @user)
  end

  test 'logged out user links' do
    visit root_path
    within '.navbar' do
      page.assert_selector("a[href='#{signup_path}']")
      page.assert_selector("a[href='#{login_path}']")
    end
  end

  test 'logged in user links' do
    login(@user)
    visit root_path
    within '.navbar' do
      page.assert_selector("a[href='#{root_path}']")
      page.assert_selector("a[href='#{logout_path}']")
      page.assert_no_selector("a[href='#{to_do_list_path(@to_do_list)}']")
    end
  end

  test 'user should see link to last visited to do list' do
    login(@user)
    visit to_do_list_path(@to_do_list)
    within '.navbar' do
      page.assert_selector("a[href='#{to_do_list_path(@to_do_list)}']")
    end
  end

  test 'user should not see link to last visited to do list if it was deleted' do
    login(@user)
    visit to_do_list_path(@to_do_list)
    click_on('Delete this list')
    within '.navbar' do
      page.assert_no_selector("a[href='#{to_do_list_path(@to_do_list)}']")
    end
  end

  test 'user should not see link to last visited to do list if it does not belong to him' do
    @another_user = create(:user)
    login(@user)
    visit to_do_list_path(@to_do_list)
    logout
    login(@another_user)
    within '.navbar' do
      page.assert_no_selector("a[href='#{to_do_list_path(@to_do_list)}']")
    end
  end
end
