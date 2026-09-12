require "test_helper"

class AdminFlowTest < ActionDispatch::IntegrationTest
  setup do
    @admin = User.create!(name: "Admin", email: "admin_test@utn.edu.ar", password: "secret123", role: :admin)
  end

  test "admin can log in and create a category" do
    get admin_login_path
    assert_response :success

    post admin_login_path, params: { email: @admin.email, password: "secret123" }
    assert_redirected_to admin_root_path

    get new_admin_category_path
    assert_response :success

    assert_difference("Category.count", 1) do
      post admin_categories_path, params: { category: { name: "Politica" } }
    end
    assert_redirected_to admin_categories_path
  end
end
