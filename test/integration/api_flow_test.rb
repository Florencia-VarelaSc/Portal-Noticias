require "test_helper"

class ApiFlowTest < ActionDispatch::IntegrationTest
  setup do
    @journalist = User.create!(name: "Per", email: "per_api@test.com", password: "secret123", role: :journalist)
    @category = Category.create!(name: "Mundo")
    @article = NewsArticle.create!(title: "Noticia publicada", body: "Contenido", user: @journalist, category: @category)
    @article.publish!
  end

  test "user can register and receive a token" do
    assert_difference("User.count", 1) do
      post "/api/v1/register", params: { user: { name: "Nuevo", email: "nuevo@test.com", password: "secret123" } }
    end
    assert_response :created
    json = JSON.parse(response.body)
    assert json["token"].present?
  end

  test "user can login and receive a token" do
    user = User.create!(name: "Lector", email: "lector_api@test.com", password: "secret123")
    post "/api/v1/login", params: { email: user.email, password: "secret123" }
    assert_response :success
    assert JSON.parse(response.body)["token"].present?
  end

  test "requires token to access protected endpoints" do
    get "/api/v1/news"
    assert_response :unauthorized
  end

  test "authenticated user can list published news, comment, and favorite" do
    reader = User.create!(name: "Lector2", email: "lector2_api@test.com", password: "secret123")
    headers = { "Authorization" => "Bearer #{reader.api_token}" }

    get "/api/v1/news", headers: headers
    assert_response :success
    assert_equal 1, JSON.parse(response.body).size

    post "/api/v1/news/#{@article.id}/comments", params: { comment: { body: "Muy buena nota" } }, headers: headers
    assert_response :created

    post "/api/v1/favorites", params: { news_article_id: @article.id }, headers: headers
    assert_response :created

    get "/api/v1/favorites", headers: headers
    assert_response :success
    assert_equal 1, JSON.parse(response.body).size

    get "/api/v1/profile", headers: headers
    assert_response :success
    assert_equal reader.email, JSON.parse(response.body)["email"]
  end
end
