
class ApplicationController < ActionController::Base

  allow_browser versions: :modern

  helper_method :current_reader, :reader_logged_in?

  private

  # Recupera al lector que inició sesión.
  def current_reader
    return nil unless session[:reader_id]

    @current_reader ||= User.find_by(
      id: session[:reader_id],
      role: :reader,
      active: true
    )
  end

  # Comprueba si hay un lector conectado.
  def reader_logged_in?
    current_reader.present?
  end

  # Protege las páginas exclusivas para lectores.
  def require_reader
    return if reader_logged_in?

    redirect_to reader_login_path,
                alert: "Tenés que iniciar sesión para continuar."
  end

end