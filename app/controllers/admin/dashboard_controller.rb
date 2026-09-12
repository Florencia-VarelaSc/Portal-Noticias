module Admin
  class DashboardController < Admin::BaseController
    def index
      @news_count = NewsArticle.count
      @published_count = NewsArticle.published.count
      @category_count = Category.count
      @user_count = User.count
    end
  end
end
