module Admin
  class CommentsController < Admin::BaseController
    def index
      @comments = Comment.includes(:user, :news_article).order(created_at: :desc)
    end

    def destroy
      Comment.find(params[:id]).destroy
      redirect_to admin_comments_path, notice: "Comentario eliminado."
    end
  end
end
