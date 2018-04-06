require 'test_helper'

class Api::V1::ToDoListItemsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
    @user2 = create(:user)
    @to_do_list = create(:to_do_list, user: @user)
    @to_do_list2 = create(:to_do_list, user: @user2)
  end

  test 'index should return unauthorized error if auth token is invalid' do
    get api_v1_to_do_list_to_do_list_items_path(@to_do_list), headers: { 'Authorization': 'some_fake_token' }
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'index should return array of all items from given list' do
    3.times do
      create(:to_do_list_item, to_do_list: @to_do_list)
    end
    get api_v1_to_do_list_to_do_list_items_path(@to_do_list), headers: { 'Authorization': @user.auth_token }
    assert json_response.size == 3
    assert json_response[0][:content] == @to_do_list.to_do_list_items.first.content
  end

  test 'index should return empty array if list does not have any items' do
    get api_v1_to_do_list_to_do_list_items_path(@to_do_list), headers: { 'Authorization': @user.auth_token }
    assert json_response == []
  end

  test 'index should return 404 if list does not belong to user' do
    get api_v1_to_do_list_to_do_list_items_path(@to_do_list2), headers: { 'Authorization': @user.auth_token }
    assert_response(404)
  end

  test 'index should return 404 if list does not exist' do
    get api_v1_to_do_list_to_do_list_items_path(99), headers: { 'Authorization': @user.auth_token }
    assert_response(404)
  end

  test 'show should return unauthorized error if auth token is invalid' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    get api_v1_to_do_list_to_do_list_item_path(@to_do_list, @to_do_list_item), headers: { 'Authorization': 'some_fake_token' }
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'show should render to do list item' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    get api_v1_to_do_list_to_do_list_item_path(@to_do_list, @to_do_list_item), headers: { 'Authorization': @user.auth_token }
    assert json_response[:content] == @to_do_list_item.content
  end

  test 'show should return 404 if list does not belong to user' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    get api_v1_to_do_list_to_do_list_item_path(@to_do_list2, @to_do_list_item), headers: { 'Authorization': @user.auth_token }
    assert_response(404)
  end

  test 'show should return 404 if list does not exist' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    get api_v1_to_do_list_to_do_list_item_path(99, @to_do_list_item), headers: { 'Authorization': @user.auth_token }
    assert_response(404)
  end

  test 'show should return 404 if item does not belong to the list' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list2)
    get api_v1_to_do_list_to_do_list_item_path(@to_do_list, @to_do_list_item), headers: { 'Authorization': @user.auth_token }
    assert_response(404)
  end

  test 'show should return 404 if item does not exist' do
    get api_v1_to_do_list_to_do_list_item_path(@to_do_list, 99), headers: { 'Authorization': @user.auth_token }
    assert_response(404)
  end

  test 'create should return unauthorized error if auth token is invalid' do
    post api_v1_to_do_list_to_do_list_items_path(@to_do_list), headers: { 'Authorization': 'some_fake_token' }, params: {
      to_do_list_item: {
        content: 'test_content'
      }
    }
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'create should create to do list item and return it in response' do
    assert_difference 'ToDoListItem.count', 1 do
      post api_v1_to_do_list_to_do_list_items_path(@to_do_list), headers: { 'Authorization': @user.auth_token }, params: {
        to_do_list_item: {
          content: 'test_content'
        }
      }
    end
    assert_response(201)
    assert json_response[:content] == ToDoListItem.last.content
  end

  test 'create should return list of errors if params are invalid' do
    assert_no_difference 'ToDoListItem.count' do
      post api_v1_to_do_list_to_do_list_items_path(@to_do_list), headers: { 'Authorization': @user.auth_token }, params: {
        to_do_list_item: {
          content: ''
        }
      }
    end
    assert_response(422)
    assert json_response[:errors].include? :content
  end

  test 'create should 404 if list does not belong to user' do
    assert_no_difference 'ToDoListItem.count' do
      post api_v1_to_do_list_to_do_list_items_path(@to_do_list2), headers: { 'Authorization': @user.auth_token }, params: {
        to_do_list_item: {
          content: 'test_content'
        }
      }
    end
    assert_response(404)
  end

  test 'create should 404 if list does not exist' do
    assert_no_difference 'ToDoListItem.count' do
      post api_v1_to_do_list_to_do_list_items_path(99), headers: { 'Authorization': @user.auth_token }, params: {
        to_do_list_item: {
          content: 'test_content'
        }
      }
    end
    assert_response(404)
  end

  test 'update should return unauthorized error if auth token is invalid' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    patch api_v1_to_do_list_to_do_list_item_path(@to_do_list, @to_do_list_item), headers: { 'Authorization': 'some_fake_token' }, params: {
      to_do_list_item: {
        content: 'content_edited',
        done: true
      }
    }
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'update should update item and return it in response' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    patch api_v1_to_do_list_to_do_list_item_path(@to_do_list, @to_do_list_item), headers: { 'Authorization': @user.auth_token }, params: {
      to_do_list_item: {
        content: 'content_edited',
        done: true
      }
    }
    assert_response(200)
    assert json_response[:content] == 'content_edited'
    assert json_response[:done] == true
  end

  test 'update should return errors if params are invalid' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    patch api_v1_to_do_list_to_do_list_item_path(@to_do_list, @to_do_list_item), headers: { 'Authorization': @user.auth_token }, params: {
      to_do_list_item: {
        content: '',
        done: true
      }
    }
    assert_response(422)
    assert json_response[:errors].include? :content
  end

  test 'update should return 404 if list does not belong to user' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    patch api_v1_to_do_list_to_do_list_item_path(@to_do_list2, @to_do_list_item), headers: { 'Authorization': @user.auth_token }, params: {
      to_do_list_item: {
        content: 'content_edited',
        done: true
      }
    }
    assert_response(404)
  end

  test 'update should return 404 if list does not exist' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list)
    patch api_v1_to_do_list_to_do_list_item_path(99, @to_do_list_item), headers: { 'Authorization': @user.auth_token }, params: {
      to_do_list_item: {
        content: 'content_edited',
        done: true
      }
    }
    assert_response(404)
  end

  test 'update should return 404 if item does not belong to list' do
    @to_do_list_item = create(:to_do_list_item, to_do_list: @to_do_list2)
    patch api_v1_to_do_list_to_do_list_item_path(@to_do_list, @to_do_list_item), headers: { 'Authorization': @user.auth_token }, params: {
      to_do_list_item: {
        content: 'content_edited',
        done: true
      }
    }
    assert_response(404)
  end

  test 'update should return 404 if item does not exist' do
    patch api_v1_to_do_list_to_do_list_item_path(@to_do_list, 99), headers: { 'Authorization': @user.auth_token }, params: {
      to_do_list_item: {
        content: 'content_edited',
        done: true
      }
    }
    assert_response(404)
  end

end
