require 'test_helper'

class UserToDoListsTest < ActionDispatch::IntegrationTest

  def setup
    @user = create(:user)
  end

  test 'no lists displayed if user is not logged in' do
    visit root_path
    within 'h3' do
      assert_text 'Log in to see your ToDoLists'
    end
  end

  test 'prompt and add button displayed when logged in but doesn\'t have any lists' do
    login(@user)
    visit root_path
    within 'h3' do
      assert_text 'You don\'t have any to do lists yet.'
    end
    assert_no_selector '.card'
    assert_selector "a[href='#{new_to_do_list_path}']"
  end

  test 'all lists displayed with titles for logged in user' do
    10.times do
      create(:to_do_list, user: @user)
    end
    login(@user)
    visit root_path
    @user.to_do_lists.each do |to_do_list|
      assert_selector "a[href='#{to_do_list_path(to_do_list)}']"
      assert_selector '.card h4', text: to_do_list.title
    end
  end

  test 'count of list elements is displayed in the card' do
    @to_do_list = create(:to_do_list, user: @user)
    3.times do
      create(:to_do_list_item, to_do_list: @to_do_list)
    end
    login(@user)
    visit root_path
    assert_selector '.card p', text: "#{@to_do_list.to_do_list_items.count} items"
  end
end
