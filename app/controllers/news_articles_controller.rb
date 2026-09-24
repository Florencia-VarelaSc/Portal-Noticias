class NewsArticlesController < ApplicationController

  def show

    # Recuperamos únicamente la noticia publicada.
    @noticia = NewsArticle
      .published
      .includes(:category, :user, cover_image_attachment: :blob)
      .find(params[:id])

    # Recuperamos los comentarios de esta noticia.
    # Incluimos los usuarios para mostrar sus nombres.
    @comentarios = @noticia.comments
      .includes(:user)
      .order(created_at: :desc)

    # Preparamos un comentario vacío para el formulario.
    @comentario = Comment.new

  end

end