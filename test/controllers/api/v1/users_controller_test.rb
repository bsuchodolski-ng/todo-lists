require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
  end

  test 'show should return serialized filtered user if request has auth header' do
    get api_v1_user_path(@user), headers: { 'Authorization': @user.auth_token }
    json_response = JSON.parse(response.body, symbolize_names: true)
    assert json_response[:email] == @user.email
    assert_not json_response.key?(:password_digest)
    assert_not json_response.key?(:auth_token)
  end

  test 'show should return unauthorized error if auth token is invalid' do
    get api_v1_user_path(@user), headers: { 'Authorization': 'some_fake_token' }
    json_response = JSON.parse(response.body, symbolize_names: true)
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'show should return 404 if token is valid but user id isn\'t' do
    @user2 = create(:user)
    get api_v1_user_path(@user2), headers: { 'Authorization': @user.auth_token }
    assert_response(404)
  end
end
