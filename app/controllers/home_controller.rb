
class HomeController < ApplicationController

  def index
    # Recuperamos únicamente las noticias publicadas
    # y las ordenamos desde la más reciente.

    @noticias = NewsArticle
      .published
      .includes(:category, :user, cover_image_attachment: :blob)
      .recent
      .limit(10)

    # La noticia más reciente será la destacada.
    @noticia_destacada = @noticias.first

    # Las demás noticias aparecerán en las tarjetas.
    @ultimas_noticias = @noticias.drop(1)
  end

end