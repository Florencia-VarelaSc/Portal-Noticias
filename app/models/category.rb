class Category < ApplicationRecord
  has_many :news_articles, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
