class Api::V1::ToDoListsController < Api::V1::BaseController

  before_action :authenticate_with_token!, only: [:index]

  def index
    @user = current_user
    render json: @user.to_do_lists, except: [:user_id], status: 200
  end

end
