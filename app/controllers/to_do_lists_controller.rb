class ToDoListsController < ApplicationController

  before_action :list_belongs_to_user, only: [:show]

  def index
    @user = current_user
  end

  def show
    to_do_list
  end

  private

    def to_do_list
      @to_do_list ||= ToDoList.find(params[:id])
    end

    def list_belongs_to_user
      unless logged_in? && current_user.to_do_lists.include?(to_do_list)
        not_found
      end
    end
end
