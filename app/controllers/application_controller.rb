class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  def not_found
    raise ActionController::RoutingError.new('Not Found')
  end
end
