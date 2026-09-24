
class ReaderCommentsController < ApplicationController

  before_action :require_reader

  def create
    @noticia = NewsArticle.published.find(
      params[:news_article_id]
    )

    @comentario = @noticia.comments.new(
      comment_params
    )

    @comentario.user = current_reader

    if @comentario.save
      redirect_to news_article_path(@noticia, anchor: "comentarios"),
                  notice: "¡Comentario publicado correctamente!"
    else
      redirect_to news_article_path(@noticia, anchor: "comentarios"),
                  alert: "No se pudo publicar el comentario."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

end