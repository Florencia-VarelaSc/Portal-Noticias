class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :news_article

  validates :user_id, uniqueness: { scope: :news_article_id, message: "already favorited this article" }
end
