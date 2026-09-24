
module Admin
  class BaseController < ActionController::Base

    layout "admin"

    before_action :require_admin_login

    helper_method :current_admin

    private

    # Recuperamos al usuario del back-office.
    def current_admin
      @current_admin ||= User.find_by(
        id: session[:admin_user_id],
        active: true
      )
    end

    # Permitimos el acceso a administradores
    # y periodistas con cuentas activas.
    def require_admin_login
      unless current_admin&.staff?
        redirect_to admin_login_path,
          alert: "Tenés que iniciar sesión para acceder al back-office."
      end
    end

    # Restringimos las funciones exclusivas
    # de los administradores.
    def require_admin_role
      unless current_admin&.admin?
        redirect_to admin_root_path,
          alert: "No tenés permisos para acceder a esta sección."
      end
    end

  end
end