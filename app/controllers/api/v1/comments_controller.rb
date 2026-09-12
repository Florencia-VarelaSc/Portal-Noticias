module Api
  module V1
    class CommentsController < Api::BaseController
      def create
        article = NewsArticle.published.find(params[:news_id])
        comment = article.comments.new(comment_params)
        comment.user = current_user
        if comment.save
          render json: { id: comment.id, body: comment.body, user: current_user.name }, status: :created
        else
          render json: { errors: comment.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Noticia no encontrada" }, status: :not_found
      end

      private

      def comment_params
        params.require(:comment).permit(:body)
      end
    end
  end
end
