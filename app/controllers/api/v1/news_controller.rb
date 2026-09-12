module Api
  module V1
    class NewsController < Api::BaseController
      include Rails.application.routes.url_helpers

      def index
        articles = NewsArticle.published.recent
        articles = articles.where(category_id: params[:category_id]) if params[:category_id].present?
        render json: articles.map { |a| article_json(a) }
      end

      def show
        article = NewsArticle.published.find(params[:id])
        render json: article_json(article, full: true)
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Noticia no encontrada" }, status: :not_found
      end

      private

      def article_json(article, full: false)
        base = {
          id: article.id,
          title: article.title,
          category: article.category.name,
          published_at: article.published_at,
          cover_image_url: article.cover_image.attached? ? rails_blob_url(article.cover_image, host: request.base_url) : nil
        }
        base[:body] = article.body if full
        base
      end
    end
  end
end
