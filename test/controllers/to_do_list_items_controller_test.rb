require 'test_helper'

class ToDoListItemsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user1 = create(:user)
    @user2 = create(:user)
    @to_do_list1 = create(:to_do_list, user: @user1)
    @to_do_list2 = create(:to_do_list, user: @user2)
    @to_do_list3 = create(:to_do_list, user: @user1)
    @to_do_list_item1 = create(:to_do_list_item, to_do_list: @to_do_list1)
    @to_do_list_item2 = create(:to_do_list_item, to_do_list: @to_do_list2)
  end

  test 'create should respond with 404 if not logged in' do
    assert_raises(ActionController::RoutingError) do
      post to_do_list_to_do_list_items_url(@to_do_list1), xhr: true, params: {
        to_do_list_item: {
          content: 'New item'
        }
      }
    end
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

  test 'update should response with 404 if user not logged in' do
    assert_raises(ActionController::RoutingError) do
      patch to_do_list_item_url(@to_do_list_item1), params: {
        to_do_list_item: {
          content: 'New item title'
        }
      }
    end
  end

  test 'update should response with 404 if item does not belong to user' do
    log_in_as(@user1)
    assert_raises(ActionController::RoutingError) do
      patch to_do_list_item_url(@to_do_list_item2), params: {
        to_do_list_item: {
          content: 'New item title'
        }
      }
    end
  end

  test 'update should update item for logged in user' do
    log_in_as(@user1)
    patch to_do_list_item_url(@to_do_list_item1), params: {
      to_do_list_item: {
        content: 'New item title'
      }
    }
    assert @to_do_list_item1.reload.content == 'New item title'
  end

  test 'update should respond with 422 if content is not present' do
    log_in_as(@user1)
    patch to_do_list_item_url(@to_do_list_item1), params: {
      to_do_list_item: {
        content: ''
      }
    }
    assert_response(422)
  end

  test 'destroy should response with 404 if user not logged in' do
    assert_raises(ActionController::RoutingError) do
      delete to_do_list_item_url(@to_do_list_item1), xhr: true
    end
  end

  test 'destroy should response with 404 if item does not belong to user' do
    log_in_as(@user1)
    assert_raises(ActionController::RoutingError) do
      delete to_do_list_item_url(@to_do_list_item2), xhr: true
    end
  end

  test 'should destroy item if item belongs to user' do
    log_in_as(@user1)
    assert_difference 'ToDoListItem.count', -1 do
      delete to_do_list_item_url(@to_do_list_item1), xhr: true
    end
  end

  test 'done should response with 404 if user not logged in' do
    assert_raises(ActionController::RoutingError) do
      patch to_do_list_item_done_url(@to_do_list_item1), xhr: true, params: {
        to_do_list_item: {
          done: true
        }
      }
    end
  end

  test 'done should response with 404 if item does not belong to user' do
    log_in_as(@user1)
    assert_raises(ActionController::RoutingError) do
      patch to_do_list_item_done_url(@to_do_list_item2), xhr: true, params: {
        to_do_list_item: {
          done: true
        }
      }
    end
  end

  test 'done should update item for logged in user' do
    log_in_as(@user1)
    patch to_do_list_item_done_url(@to_do_list_item1), xhr: true, params: {
      to_do_list_item: {
        done: true
      }
    }
    assert @to_do_list_item1.reload.done?
  end

end
