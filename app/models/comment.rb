class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :news_article

  validates :body, presence: true
end
