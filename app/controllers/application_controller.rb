class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = 'Please log in and try again.'
        redirect_to login_path
      end
    end
end
