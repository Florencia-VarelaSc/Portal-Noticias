module Api
  module V1
    class FavoritesController < Api::BaseController
      def index
        favorites = current_user.favorites.includes(:news_article)
        render json: favorites.map { |f| { id: f.id, news_article_id: f.news_article_id, title: f.news_article.title } }
      end

      def create
        article = NewsArticle.published.find(params[:news_article_id] || params.dig(:favorite, :news_article_id))
        favorite = current_user.favorites.new(news_article: article)
        if favorite.save
          render json: { id: favorite.id, news_article_id: article.id }, status: :created
        else
          render json: { errors: favorite.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Noticia no encontrada" }, status: :not_found
      end

      def destroy
        favorite = current_user.favorites.find(params[:id])
        favorite.destroy
        head :no_content
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Favorito no encontrado" }, status: :not_found
      end
    end
  end
end
