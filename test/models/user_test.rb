require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "requires a unique email" do
    User.create!(name: "A", email: "dup@test.com", password: "secret123")
    dup = User.new(name: "B", email: "dup@test.com", password: "secret123")
    assert_not dup.valid?
  end

  test "generates an api token on creation" do
    user = User.create!(name: "A", email: "tok@test.com", password: "secret123")
    assert_not_nil user.api_token
  end

  test "staff? is true for journalist and admin" do
    reader = User.new(role: :reader)
    journalist = User.new(role: :journalist)
    admin = User.new(role: :admin)
    assert_not reader.staff?
    assert journalist.staff?
    assert admin.staff?
  end
end
