class ToDoListItemsController < ApplicationController

  before_action :logged_in_user, only: [:create]
  before_action :list_belongs_to_user, only: [:create]

  def create
    @to_do_list_item = ToDoListItem.new(to_do_list_item_params.merge(to_do_list_id: params[:to_do_list_id]))
    @to_do_list_item.save!
    respond_to do |format|
      format.js
    end
  end

  def update
  end

  private
    def to_do_list_item_params
      params.require(:to_do_list_item).permit(:content, :to_do_list_id)
    end
end
