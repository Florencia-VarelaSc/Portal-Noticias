
class ReaderRegistrationsController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Los usuarios registrados desde el portal
    # siempre tendrán el rol de lector.
    @user.role = :reader

    if @user.save
      # Iniciamos la sesión del nuevo lector.
      reset_session
      session[:reader_id] = @user.id

      # Enviamos el correo de bienvenida.
      UserMailer.welcome_email(@user).deliver_later

      redirect_to root_path,
                  notice: "¡Bienvenido al Portal de Noticias, #{@user.name}!"

    else
      # Si hay errores, mostramos nuevamente
      # el formulario sin perder los datos ingresados.
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :password,
      :password_confirmation
    )
  end

end