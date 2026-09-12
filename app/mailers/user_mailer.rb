class UserMailer < ApplicationMailer
  default from: "noreply@sistema-noticias.test"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "Bienvenido al sistema de noticias")
  end
end
