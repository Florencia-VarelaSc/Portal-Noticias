module Api
  module V1
    class RegistrationsController < ActionController::API
      def create
        user = User.new(user_params)
        user.role = :reader
        if user.save
          UserMailer.welcome_email(user).deliver_later
          render json: { id: user.id, name: user.name, email: user.email, token: user.api_token }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def user_params
        params.require(:user).permit(:name, :email, :password)
      end
    end
  end
end
