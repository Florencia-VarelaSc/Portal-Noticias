module Admin
  class SessionsController < ActionController::Base
    layout "admin"
    helper_method :current_admin

    def new
    end

    def create
      user = User.find_by(email: params[:email])
      if user&.staff? && user.active? && user.authenticate(params[:password])
        session[:admin_user_id] = user.id
        redirect_to admin_root_path, notice: "Bienvenido, #{user.name}"
      else
        flash.now[:alert] = "Email o contraseña incorrectos, o no tenés permisos de administrador."
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:admin_user_id] = nil
      redirect_to admin_login_path, notice: "Sesión cerrada."
    end

    private

    def current_admin
      @current_admin ||= User.find_by(id: session[:admin_user_id])
    end
  end
end
