module Api
  module V1
    class ProfilesController < Api::BaseController
      def show
        render json: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email,
          role: current_user.role,
          favorites_count: current_user.favorites.count
        }
      end
    end
  end
end
