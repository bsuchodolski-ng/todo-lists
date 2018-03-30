class Api::V1::SessionsController < Api::BaseController

  def create
    @user = User.find_by(email: params[:email])
    if @user && @user.authenticate(params[:password])
      @user.regenerate_auth_token
      render json: { token: @user.auth_token }, status: 200
    else
      render json: { errors: I18n.t('api.session.wrong_credentials') }, status: 422
    end
  end

  def destroy
    @user = User.find_by(auth_token: params[:token])
    if @user.present?
      @user.regenerate_auth_token
      head 204
    else
      head 404
    end
  end

end
