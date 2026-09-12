class User < ApplicationRecord
  has_secure_password

  enum :role, { reader: 0, journalist: 1, admin: 2 }

  has_many :news_articles, foreign_key: :user_id, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_articles, through: :favorites, source: :news_article

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
                     format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true

  before_create :generate_api_token

  def staff?
    journalist? || admin?
  end

  def regenerate_api_token!
    update!(api_token: SecureRandom.hex(24))
  end

  private

  def generate_api_token
    self.api_token ||= SecureRandom.hex(24)
  end
end
