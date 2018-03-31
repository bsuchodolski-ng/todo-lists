class Api::V1::UsersController < Api::V1::BaseController

  before_action :authenticate_with_token!, only: [:show, :update]

  def show
    @user = User.find_by(id: params[:id])
    if @user && @user.eql?(current_user)
      render json: @user.as_json(except: [:password_digest, :auth_token])
    else
      head 404
    end
  end

end
