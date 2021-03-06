require 'test_helper'

class ToDoListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user1 = create(:user)
    @user2 = create(:user)
    @to_do_list1 = create(:to_do_list, user: @user1)
    @to_do_list2 = create(:to_do_list, user: @user2)
  end

  test "should get index" do
    get to_do_lists_url
    assert_response :success
  end

  test 'new should redirect to login if not logged in' do
    get new_to_do_list_url
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should get new if logged in' do
    log_in_as(@user1)
    get new_to_do_list_url
    assert_response :success
  end

  test 'create should redirect to login if not logged in' do
    assert_no_difference 'ToDoList.count' do
      post to_do_lists_url, params: {
        to_do_list: {
          title: 'Title',
          user_id: @user1.id
        }
      }
    end
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'should create to do list if logged in' do
    log_in_as(@user1)
    assert_difference 'ToDoList.count', 1 do
      post to_do_lists_url, params: {
        to_do_list: {
          title: 'Title',
          user_id: @user1.id
        }
      }
    end
    assert_redirected_to to_do_list_url(ToDoList.last)
  end

  test 'should always create to do list for the logged in user' do
    log_in_as(@user1)
    assert_difference 'ToDoList.count', 1 do
      post to_do_lists_url, params: {
        to_do_list: {
          title: 'Title',
          user_id: @user2.id
        }
      }
    end
    assert ToDoList.last.user_id = @user1.id
  end

  test 'show should response with 404 if user not logged in' do
    assert_raises(ActionController::RoutingError) do
      get to_do_list_url(@to_do_list1)
    end
  end

  test 'show should response with 404 if list does not belong to user' do
    log_in_as(@user1)
    assert_raises(ActionController::RoutingError) do
      get to_do_list_url(@to_do_list2)
    end
  end

  test 'should show list if list belongs to user and stores its id in session' do
    log_in_as(@user1)
    get to_do_list_url(@to_do_list1)
    assert_response :success
    assert session[:last_list_id] == @to_do_list1.id
  end


  test 'update should response with 404 if user not logged in' do
    assert_raises(ActionController::RoutingError) do
      patch to_do_list_url(@to_do_list1), params: {
        to_do_list: {
          title: 'New title'
        }
      }
    end
  end

  test 'update should response with 404 if list does not belong to user' do
    log_in_as(@user1)
    assert_raises(ActionController::RoutingError) do
      patch to_do_list_url(@to_do_list2), params: {
        to_do_list: {
          title: 'New title'
        }
      }
    end
  end

  test 'update should update to do list for logged in user' do
    log_in_as(@user1)
    patch to_do_list_url(@to_do_list1), params: {
      to_do_list: {
        title: 'New title'
      }
    }
    assert @to_do_list1.reload.title == 'New title'
  end

  test 'update should respond with 422 if title is not present' do
    log_in_as(@user1)
    patch to_do_list_url(@to_do_list1), params: {
      to_do_list: {
        title: ''
      }
    }
    assert_response(422)
  end

  test 'destroy should response with 404 if user not logged in' do
    assert_raises(ActionController::RoutingError) do
      delete to_do_list_url(@to_do_list1)
    end
  end

  test 'destroy should response with 404 if list does not belong to user' do
    log_in_as(@user1)
    assert_raises(ActionController::RoutingError) do
      delete to_do_list_url(@to_do_list2)
    end
  end

  test 'should destroy list if list belongs to user' do
    log_in_as(@user1)
    assert_difference 'ToDoList.count', -1 do
      delete to_do_list_url(@to_do_list1)
    end
    assert_redirected_to to_do_lists_url
  end
end
