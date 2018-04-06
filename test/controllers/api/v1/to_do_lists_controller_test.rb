require 'test_helper'

class Api::V1::ToDoListsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
  end

  test 'index should return unauthorized error if auth token is invalid' do
    get api_v1_to_do_lists_path, headers: { 'Authorization': 'some_fake_token' }
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'index should return to do lists if auth token is valid' do
    3.times do
      create(:to_do_list, user: @user)
    end
    get api_v1_to_do_lists_path, headers: { 'Authorization': @user.auth_token }
    assert json_response.size == 3
    assert json_response[0][:title] == @user.to_do_lists.first.title
  end

  test 'index should return empty array if there are no to do lists' do
    get api_v1_to_do_lists_path, headers: { 'Authorization': @user.auth_token }
    assert json_response == []
  end

end
