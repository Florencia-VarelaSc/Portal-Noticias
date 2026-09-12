module Admin
  class BaseController < ActionController::Base
    layout "admin"
    before_action :require_admin_login

    helper_method :current_admin

    private

    def current_admin
      @current_admin ||= User.find_by(id: session[:admin_user_id])
    end

    def require_admin_login
      unless current_admin&.staff?
        redirect_to admin_login_path, alert: "Tenés que iniciar sesión para acceder al back-office."
      end
    end
  end
end
