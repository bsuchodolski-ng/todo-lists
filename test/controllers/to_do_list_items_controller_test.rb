require 'test_helper'

class ToDoListItemsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = create(:user)
    @user2 = create(:user)
    @to_do_list1 = create(:to_do_list, user: @user1)
    @to_do_list2 = create(:to_do_list, user: @user2)
  end

  test 'create should redirect to login if not logged in' do
    assert_no_difference 'ToDoListItem.count' do
      post to_do_list_to_do_list_items_url(@to_do_list1), xhr: true, params: {
        to_do_list_item: {
          content: 'New item'
        }
      }
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should create item if user is logged in' do
    log_in_as(@user1)
    assert_difference 'ToDoListItem.count', 1 do
      post to_do_list_to_do_list_items_url(@to_do_list1), xhr: true, params: {
        to_do_list_item: {
          content: 'New item'
        }
      }
    end
  end

  test 'create should return errors in json if validation fails' do
    log_in_as(@user1)
    assert_no_difference 'ToDoListItem.count' do
      post to_do_list_to_do_list_items_url(@to_do_list1), xhr: true, params: {
        to_do_list_item: {
          content: ''
        }
      }
    end
    assert_response(422)
    assert_equal '{"content":["can\'t be blank"]}', response.body
  end

  test 'create should respond with 404 if to do list does not belong to user' do
    assert_raises(ActionController::RoutingError) do
      log_in_as(@user1)
      post to_do_list_to_do_list_items_url(@to_do_list2), xhr: true, params: {
        to_do_list_item: {
          content: 'New item'
        }
      }
    end
  end
end
