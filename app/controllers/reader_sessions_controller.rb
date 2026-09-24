
class ReaderSessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(
      email: params[:email].to_s.strip.downcase
    )

    if user&.active? &&
       user&.reader? &&
       user.authenticate(params[:password])

      reset_session

      session[:reader_id] = user.id

      redirect_to root_path,
        notice: "¡Bienvenido, #{user.name}!"

    else

      flash.now[:alert] =
        "Correo o contraseña incorrectos."

      render :new,
        status: :unprocessable_entity

    end
  end

  def destroy
    session.delete(:reader_id)

    redirect_to root_path,
      notice: "Cerraste sesión correctamente."
  end

end