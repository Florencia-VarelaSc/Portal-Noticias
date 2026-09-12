require "test_helper"

class FavoriteTest < ActiveSupport::TestCase
  setup do
    @author = User.create!(name: "Autor", email: "autor@test.com", password: "secret123", role: :journalist)
    @reader = User.create!(name: "Lector", email: "lector@test.com", password: "secret123")
    @category = Category.create!(name: "Deportes")
    @article = NewsArticle.create!(title: "T", body: "B", user: @author, category: @category)
  end

  test "a user cannot favorite the same article twice" do
    Favorite.create!(user: @reader, news_article: @article)
    duplicate = Favorite.new(user: @reader, news_article: @article)
    assert_not duplicate.valid?
  end
end
