
class ReaderFavoritesController < ApplicationController

  before_action :require_reader

  def index
    @favoritos = current_reader.favorites
      .includes(news_article: [
        :category,
        { cover_image_attachment: :blob }
      ])
      .order(created_at: :desc)
  end

  def create
    noticia = NewsArticle.published.find(
      params[:news_article_id]
    )

    favorito = current_reader.favorites.find_or_initialize_by(
      news_article: noticia
    )

    if favorito.save
      redirect_to news_article_path(noticia),
                  notice: "Noticia guardada en favoritos."
    else
      redirect_to news_article_path(noticia),
                  alert: "No se pudo guardar la noticia."
    end
  end

  def destroy
    favorito = current_reader.favorites.find(params[:id])

    favorito.destroy!

    redirect_to reader_favorites_path,
                notice: "Noticia eliminada de favoritos."
  end

end