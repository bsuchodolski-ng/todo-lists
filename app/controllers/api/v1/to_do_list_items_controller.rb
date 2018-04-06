class Api::V1::ToDoListItemsController < Api::V1::BaseController

  before_action :authenticate_with_token!, only: [:index, :show, :create, :update, :destroy]
  before_action :list_belongs_to_user, only: [:index, :show, :create, :update, :destroy]

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

  def create
    @to_do_list_item = to_do_list.to_do_list_items.new(to_do_list_item_params)
    if @to_do_list_item.save
      render json: @to_do_list_item, status: 201
    else
      render json: { errors: @to_do_list_item.errors }, status: 422
    end
  end

  def update
    @to_do_list_item = to_do_list.to_do_list_items.find_by(id: params[:id])
    if @to_do_list_item
      if @to_do_list_item.update(to_do_list_item_params)
        render json: @to_do_list_item
      else
        render json: { errors: @to_do_list_item.errors }, status: 422
      end
    else
      head 404
    end
  end

  def destroy
    @to_do_list_item = to_do_list.to_do_list_items.find_by(id: params[:id])
    if @to_do_list_item
      @to_do_list_item.destroy
      head 204
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

  def to_do_list_item_params
    params.require(:to_do_list_item).permit(:content, :done)
  end

end
