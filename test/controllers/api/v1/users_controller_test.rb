require 'test_helper'

class Api::V1::UsersControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = create(:user)
  end

  test 'show should return serialized filtered user if request has auth header' do
    get api_v1_user_path(@user), headers: { 'Authorization': @user.auth_token }
    assert json_response[:email] == @user.email
    assert_not json_response.key?(:password_digest)
    assert_not json_response.key?(:auth_token)
  end

  test 'show should return unauthorized error if auth token is invalid' do
    get api_v1_user_path(@user), headers: { 'Authorization': 'some_fake_token' }
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'show should return 404 if token is valid but user id isn\'t' do
    @user2 = create(:user)
    get api_v1_user_path(@user2), headers: { 'Authorization': @user.auth_token }
    assert_response(404)
  end

  test 'show should return 404 if user does not exist' do
    get api_v1_user_path(99), headers: { 'Authorization': @user.auth_token }
    assert response.body.empty?
    assert_response(404)
  end

  test 'update should update user details and return user if request has auth header' do
    patch api_v1_user_path(@user), headers: { 'Authorization': @user.auth_token }, params: {
      user: {
        email: 'test_user_email@example.com'
      }
    }
    assert json_response[:email] == 'test_user_email@example.com'
  end

  test 'update should return unauthorized error id auth token is invalid' do
    patch api_v1_user_path(@user), headers: { 'Authorization': 'some_fake_token' }, params: {
      user: {
        email: 'test_user_email@example.com'
      }
    }
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'update should return errors in response if there are some' do
    patch api_v1_user_path(@user), headers: { 'Authorization': @user.auth_token }, params: {
      user: {
        email: 'invalidmail',
        password: 'short',
        password_confirmation: 'not_the_same'
      }
    }
    assert json_response[:errors].size == 3
    assert json_response[:errors].include? :password_confirmation
    assert json_response[:errors].include? :password
    assert json_response[:errors].include? :email
  end

  test 'update should return 404 if token is valid but user id isn\'t' do
    @user2 = create(:user)
    patch api_v1_user_path(@user2), headers: { 'Authorization': @user.auth_token }, params: {
      user: {
        email: 'test_user_email@example.com'
      }
    }
    assert_response(404)
  end

  test 'update should return 404 if user does not exist' do
    patch api_v1_user_path(99), headers: { 'Authorization': @user.auth_token }, params: {
      user: {
        email: 'test_user_email@example.com'
      }
    }
    assert response.body.empty?
    assert_response(404)
  end

  test 'destroy should delete current user and return 204 response' do
    assert_difference 'User.count', -1 do
      delete api_v1_user_path(@user), headers: { 'Authorization': @user.auth_token }
    end
    assert_response(204)
  end

  test 'destroy should return unauthorized error if token is invalid' do
    assert_no_difference 'User.count' do
      delete api_v1_user_path(@user), headers: { 'Authorization': 'some_fake_token' }
    end
    assert json_response[:errors] == I18n.t('api.base.not_authenticated')
    assert_response(401)
  end

  test 'destroy should return 404 if token is valid but user id isn\'t' do
    @user2 = create(:user)
    assert_no_difference 'User.count' do
      delete api_v1_user_path(@user2), headers: { 'Authorization': @user.auth_token }
    end
    assert response.body.empty?
    assert_response(404)
  end

  test 'destroy should return 404 if user does not exist' do
    assert_no_difference 'User.count' do
      delete api_v1_user_path(99), headers: { 'Authorization': @user.auth_token }
    end
    assert response.body.empty?
    assert_response(404)
  end
end
