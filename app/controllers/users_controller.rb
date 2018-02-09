class UsersController < ApplicationController

  before_action :logged_in_user, only: [:edit, :update, :destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:success] = 'Your account was successfuly created'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update_attributes(user_params)
      flash[:success] = 'Your account was successfully saved.'
      redirect_to account_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = current_user
    log_out
    @user.destroy
    flash[:danger] = 'Your account was successfully deleted.'
    redirect_to root_path
  end

  private

    def user_params
      params.require(:user).permit(:email, :password, :password_confirmation)
    end
end
