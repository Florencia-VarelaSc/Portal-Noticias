class NewsArticle < ApplicationRecord
  belongs_to :user
  belongs_to :category

  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_one_attached :cover_image

  enum :status, { draft: 0, published: 1, archived: 2 }

  validates :title, presence: true
  validates :body, presence: true
  validate :published_articles_must_have_published_at

  scope :recent, -> { order(published_at: :desc) }

  def publish!
    update!(status: :published, published_at: Time.current)
  end

  def archive!
    update!(status: :archived)
  end

  private

  def published_articles_must_have_published_at
    if published? && published_at.blank?
      errors.add(:published_at, "must be present when the article is published")
    end
  end
end
