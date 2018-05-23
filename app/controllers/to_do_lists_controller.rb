class ToDoListsController < ApplicationController

  before_action :list_belongs_to_user, only: [:update, :destroy]
  before_action :logged_in_user, only: [:new, :create]

  def index
    @user = current_user
  end

  def show
    session[:last_list_id] = to_do_list.id
  end

  def new
    @to_do_list = ToDoList.new
  end

  def create
    @to_do_list = current_user.to_do_lists.new(to_do_list_params)
    if @to_do_list.save
      flash[:success] = I18n.t('to_do_list.flashes.list_created')
      redirect_to to_do_list_path(@to_do_list)
    else
      render 'new'
    end
  end

  def update
    @to_do_list = ToDoList.find(params[:id])
    @to_do_list.update(to_do_list_params)
    respond_with_bip(@to_do_list)
  end

  def destroy
    @to_do_list = ToDoList.find(params[:id])
    @to_do_list.destroy
    flash[:danger] = I18n.t('to_do_list.flashes.list_deleted')
    redirect_to to_do_lists_path
  end

  private

    def to_do_list_params
      params.require(:to_do_list).permit(:title)
    end

    def to_do_list
      @to_do_list ||= ToDoList.find(params[:id])
    end
end
