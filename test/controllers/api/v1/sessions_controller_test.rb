require 'test_helper'

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
  end

  test 'create should return user token' do
    get api_v1_token_path, params: {
      email: @user.email,
      password: @user.password
    }
    json_response = JSON.parse(response.body, symbolize_names: true)
    assert json_response[:token] == @user.reload.auth_token
  end

  test 'create should return error if email or password is invalid' do
    get api_v1_token_path, params: {
      email: "invalid_email",
      password: "invalid password"
    }
    json_response = JSON.parse(response.body, symbolize_names: true)
    assert json_response[:errors] == I18n.t('api.session.wrong_credentials')
    assert_response(422)
  end

  test 'destroy should regenerate token if it exists' do
    delete api_v1_token_path, params: {
      token: @user.auth_token
    }
    assert @user.auth_token != @user.reload.auth_token
    assert_response(204)
  end

  test 'destroy should return 404 if token does not exist' do
    delete api_v1_token_path, params: {
      token: "some_fake_token"
    }
    assert_response(404)
  end
end
