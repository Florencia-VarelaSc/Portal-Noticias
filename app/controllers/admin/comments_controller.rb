
module Admin
  class CommentsController < Admin::BaseController

    def index
      # El administrador puede ver todos los comentarios.
      # El periodista solo ve los de sus propias noticias.

      @comments = Comment.includes(:user, :news_article)

      unless current_admin.admin?
        @comments = @comments.joins(:news_article)
          .where(news_articles: { user_id: current_admin.id })
      end

      @comments = @comments.order(created_at: :desc)
    end

    def destroy
      # Buscamos el comentario.
      @comment = Comment.find(params[:id])

      # Comprobamos los permisos.
      unless current_admin.admin? ||
             @comment.news_article.user_id == current_admin.id

        redirect_to admin_comments_path,
          alert: "No tenés permisos para eliminar este comentario."

        return
      end

      # Eliminamos el comentario.
      @comment.destroy!

      redirect_to admin_comments_path,
        notice: "Comentario eliminado."
    end

  end
end