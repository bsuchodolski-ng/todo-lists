class ToDoListItemsController < ApplicationController

  before_action :logged_in_user, only: [:create]
  before_action :list_belongs_to_user, only: [:create]

  def create
    @to_do_list_item = ToDoListItem.new(to_do_list_item_params.merge(to_do_list_id: params[:to_do_list_id]))
    respond_to do |format|
      if @to_do_list_item.save
        format.js
      else
        format.js {render json: @to_do_list_item.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
  end

  private
    def to_do_list_item_params
      params.require(:to_do_list_item).permit(:content)
    end
end
