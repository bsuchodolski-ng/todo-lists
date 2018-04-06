class Api::V1::ToDoListItemsController < Api::V1::BaseController

  before_action :authenticate_with_token!, only: [:index]
  before_action :list_belongs_to_user, only: [:index]

  def index
    render json: to_do_list.to_do_list_items
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
