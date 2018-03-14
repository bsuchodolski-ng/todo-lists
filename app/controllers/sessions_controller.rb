class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by(email: params[:session][:email])
    if @user && @user.authenticate(params[:session][:password])
      log_in @user
      flash[:success] = I18n.t('session.flashes.logged_in')
      redirect_to root_path
    else
      flash.now[:danger] = I18n.t('session.flashes.wrong_credentials')
      render 'new'
    end
  end

  def destroy
    log_out if logged_in?
    flash[:success] = I18n.t('session.flashes.logged_out')
    redirect_to root_url
  end
end
