class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end

  private
    def logged_in_user
      unless logged_in?
        flash[:danger] = I18n.t('application.flashes.log_in')
        redirect_to login_path
      end
    end

    def list_belongs_to_user
      unless logged_in? && current_user.to_do_lists.include?(to_do_list)
        not_found
      end
    end
end
