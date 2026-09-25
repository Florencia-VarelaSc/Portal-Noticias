
module Admin
  class UsersController < Admin::BaseController

    # Solo los administradores pueden gestionar usuarios.
    before_action :require_admin_role

    before_action :set_user, only: [:edit, :update]

    def index
      @users = User.order(:name)
    end

    def edit
    end

    def update
  if @user.update(user_params)

    redirect_to admin_users_path,
      notice: "Usuario actualizado."

  else

    render :edit,
      status: :unprocessable_entity

  end
end

    private

    def set_user
      @user = User.find(params[:id])
    end
    def user_params
  params.require(:user).permit(:active, :role)
end

  end
end