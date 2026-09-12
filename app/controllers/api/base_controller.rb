module Api
  class BaseController < ActionController::API
    before_action :authenticate_user!

    attr_reader :current_user

    private

    def authenticate_user!
      token = request.headers["Authorization"]&.split("Bearer ")&.last
      @current_user = User.find_by(api_token: token) if token.present?

      unless @current_user&.active?
        render json: { error: "No autorizado. Enviá un token válido en el header Authorization: Bearer <token>." }, status: :unauthorized
      end
    end
  end
end
