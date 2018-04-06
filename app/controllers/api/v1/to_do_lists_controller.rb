class Api::V1::ToDoListsController < Api::V1::BaseController

  before_action :authenticate_with_token!, only: [:index, :show, :create]

  def index
    @user = current_user
    render json: @user.to_do_lists, except: [:user_id], status: 200
  end

  def show
    @user = current_user
    @to_do_list = @user.to_do_lists.find_by(id: params[:id])
    if @to_do_list
      render json: @to_do_list, except: [:user_id], status: 200
    else
      head 404
    end
  end

  def create
    @user = current_user
    @to_do_list = @user.to_do_lists.new(to_do_list_params)
    if @to_do_list.save
      render json: @to_do_list, except: [:user_id], status: 201
    else
      render json: { errors: @to_do_list.errors }, status: 422
    end
  end

  private

  def to_do_list_params
    params.require(:to_do_list).permit(:title)
  end

end
