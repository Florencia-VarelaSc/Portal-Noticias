module Api
  module V1
    class SessionsController < ActionController::API
      def create
        user = User.find_by(email: params[:email])
        if user&.active? && user.authenticate(params[:password])
          render json: { token: user.api_token, name: user.name, email: user.email }
        else
          render json: { error: "Credenciales inválidas" }, status: :unauthorized
        end
      end
    end
  end
end
