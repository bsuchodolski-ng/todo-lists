class Api::V1::UsersController < Api::V1::BaseController

  before_action :authenticate_with_token!, only: [:show, :update, :destroy]
  before_action :is_authorized, only: [:show, :update, :destroy]

  def show
    if user
      render json: user, except: [:password_digest, :auth_token]
    else
      head 404
    end
  end

  def update
    if user.update(user_params)
      render json: user, except: [:password_digest, :auth_token], status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    user.destroy
    head 204
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def is_authorized
    unless user.eql?(current_user)
      head 404
    end
  end

  def user
    @user ||= User.find_by(id: params[:id])
  end

end
