class Api::V1::ToDoListItemsController < Api::V1::BaseController

  before_action :authenticate_with_token!, only: [:index, :show]
  before_action :list_belongs_to_user, only: [:index, :show]

  def index
    render json: to_do_list.to_do_list_items
  end

  def show
    @to_do_list_item = to_do_list.to_do_list_items.find_by(id: params[:id])
    if @to_do_list_item
      render json: @to_do_list_item
    else
      head 404
    end
  end

  private

  def to_do_list
    @to_do_list ||= ToDoList.find_by(id: params[:to_do_list_id])
  end

  def list_belongs_to_user
    unless current_user.to_do_lists.include?(to_do_list)
      head 404
    end
  end

end
