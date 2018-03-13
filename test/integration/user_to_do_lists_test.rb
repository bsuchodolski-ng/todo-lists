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

  test 'complete to do list flow with adding and deleting to do list items' do
    login(@user)
    visit root_path
    # Adding new ToDo List
    click_on('Add ToDo List')
    click_on('Create ToDo list')
    assert_text 'Title can\'t be blank'
    fill_in 'to_do_list_title', with: 'Test title'
    click_on('Create ToDo list')
    # Changing ToDo List title in place
    assert_text 'Test title'
    @to_do_list = ToDoList.last
    bip_text(@to_do_list, :title, '')
    assert_text 'Test title'
    bip_text(@to_do_list, :title, 'Title edited')
    assert_text 'Title edited'
    # Adding new ToDo list item
    assert_no_difference 'ToDoListItem.count' do
      fill_in 'to_do_list_item[content]', with: ''
      click_on('Add new list item')
    end
    fill_in 'to_do_list_item[content]', with: 'New to do list item'
    click_on('Add new list item')
    within '#to_do_list_item1' do
      assert_text 'New to do list item'
    end
    # Editing ToDo list item
    @to_do_list_item = ToDoListItem.last
    bip_text(@to_do_list_item, :content, '')
    within '#to_do_list_item1' do
      assert_text 'New to do list item'
    end
    bip_text(@to_do_list_item, :content, 'Item edited')
    within '#to_do_list_item1' do
      assert_text 'Item edited'
    end
    # Marking ToDo list item as done
    page.find('input[name="to_do_list_item[done]"]').click
    assert page.find('#to_do_list_item1')[:class].include?('done')
    # Unmarking ToDo list item as done
    page.find('input[name="to_do_list_item[done]"]').click
    assert_not page.find('#to_do_list_item1')[:class].include?('done')
    # Deleting ToDo list item
    within '#to_do_list_item1' do
      click_on('Delete')
    end
    assert_no_selector '#to_do_list_item1'
    # Deleting ToDo list
    click_on('Delete this list')
    assert_text 'You don\'t have any to do lists yet.'
    assert_selector '.alert.alert-danger', text: 'To do list was successfully deleted.'
  end
end
