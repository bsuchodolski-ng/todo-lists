class Api::V1::BaseController < ActionController::Base

  def current_user
    @current_user ||= User.find_by(auth_token: request.headers['Authorization'])
  end

  private

    def authenticate_with_token!
      unless current_user.present?
        render json: { errors: I18n.t('api.base.not_authenticated') }, status: :unauthorized
      end
    end
end
