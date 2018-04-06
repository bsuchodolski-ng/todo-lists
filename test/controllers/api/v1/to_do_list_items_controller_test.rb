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
end
