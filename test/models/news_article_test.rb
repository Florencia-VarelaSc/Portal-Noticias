require "test_helper"

class NewsArticleTest < ActiveSupport::TestCase
  setup do
    @user = User.create!(name: "Periodista", email: "per@test.com", password: "secret123", role: :journalist)
    @category = Category.create!(name: "Tecnologia")
  end

  test "is invalid without title or body" do
    article = NewsArticle.new(user: @user, category: @category)
    assert_not article.valid?
    assert_includes article.errors[:title], "can't be blank"
    assert_includes article.errors[:body], "can't be blank"
  end

  test "starts as draft by default" do
    article = NewsArticle.create!(title: "T", body: "B", user: @user, category: @category)
    assert article.draft?
  end

  test "publish! sets status and published_at" do
    article = NewsArticle.create!(title: "T", body: "B", user: @user, category: @category)
    article.publish!
    assert article.published?
    assert_not_nil article.published_at
  end

  test "cannot be saved as published without published_at" do
    article = NewsArticle.new(title: "T", body: "B", user: @user, category: @category, status: :published)
    assert_not article.valid?
    assert_includes article.errors[:published_at], "must be present when the article is published"
  end
end
