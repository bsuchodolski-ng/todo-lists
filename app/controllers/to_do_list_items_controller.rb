class ToDoListItemsController < ApplicationController

  before_action :list_belongs_to_user, only: [:create]
  before_action :item_belongs_to_user, only: [:update, :destroy]

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

  def destroy
    respond_to do |format|
      @to_do_list_item = ToDoListItem.find(params[:id])
      @to_do_list_item.destroy
      format.js
    end
  end

  private
    def to_do_list_item_params
      params.require(:to_do_list_item).permit(:content)
    end

    def to_do_list
      @to_do_list ||= ToDoList.find(params[:to_do_list_id])
    end

    def to_do_list_item
      @to_do_list_item ||= ToDoListItem.find(params[:id])
    end

    def item_belongs_to_user
      unless logged_in? && current_user.to_do_lists.include?(to_do_list_item.to_do_list)
        not_found
      end
    end
end
