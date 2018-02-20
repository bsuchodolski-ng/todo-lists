class ToDoListItemsController < ApplicationController

  before_action :list_belongs_to_user, only: [:create, :update]

  def create
    @to_do_list_item = ToDoListItem.new(to_do_list_item_params.merge(to_do_list_id: params[:to_do_list_id]))
    respond_to do |format|
      if @to_do_list_item.save
        format.js
      else
        format.json {render json: @to_do_list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @to_do_list_item = ToDoListItem.find(params[:id])
    @to_do_list_item.update(to_do_list_item_params)
    respond_with_bip(@to_do_list_item)
  end

  private
    def to_do_list_item_params
      params.require(:to_do_list_item).permit(:content)
    end

    def to_do_list
      @to_do_list ||= ToDoList.find(params[:to_do_list_id])
    end
end
