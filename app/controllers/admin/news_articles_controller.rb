module Admin
  class NewsArticlesController < Admin::BaseController
    before_action :set_news_article, only: [ :show, :edit, :update, :destroy, :publish, :archive ]

    def index
      @news_articles = NewsArticle.order(created_at: :desc)
    end

    def show
    end

    def new
      @news_article = NewsArticle.new
    end

    def create
      @news_article = NewsArticle.new(news_article_params)
      @news_article.user = current_admin
      if @news_article.save
        redirect_to admin_news_articles_path, notice: "Noticia creada."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @news_article.update(news_article_params)
        redirect_to admin_news_articles_path, notice: "Noticia actualizada."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @news_article.destroy
      redirect_to admin_news_articles_path, notice: "Noticia eliminada."
    end

    def publish
      @news_article.publish!
      redirect_to admin_news_articles_path, notice: "Noticia publicada."
    end

    def archive
      @news_article.archive!
      redirect_to admin_news_articles_path, notice: "Noticia archivada."
    end

    private

    def set_news_article
      @news_article = NewsArticle.find(params[:id])
    end

    def news_article_params
      params.require(:news_article).permit(:title, :body, :category_id, :cover_image)
    end
  end
end
