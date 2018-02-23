require 'test_helper'

class UserToDoListsTest < ActionDispatch::IntegrationTest

  def setup
    @user = create(:user)
  end

  test 'no lists displayed if user is not logged in' do
    get root_path
    assert_select "h3", "Log in to see your ToDoLists"
    assert_select ".card", false
    assert_select "a[href=?]", new_to_do_list_path, false
  end

  test 'prompt and add button displayed when logged in but doesn\'t have any lists' do
    log_in_as(@user)
    get root_path
    assert_select "h3", "You don't have any to do lists yet."
    assert_select ".card", false
    assert_select "a[href=?]", new_to_do_list_path
  end

  test 'all lists displayed with titles for logged in user' do
    10.times do
      create(:to_do_list, user: @user)
    end
    log_in_as(@user)
    get root_path
    @user.to_do_lists.each do |to_do_list|
      assert_select "a[href=?]", to_do_list_path(to_do_list)
      assert_select ".card h4", text: to_do_list.title
    end
  end

  test 'count of list elements is displayed in the card' do
    @to_do_list = create(:to_do_list, user: @user)
    3.times do
      create(:to_do_list_item, to_do_list: @to_do_list)
    end
    log_in_as(@user)
    get root_path
    assert_select ".card p", text: "3 items"
  end

end
