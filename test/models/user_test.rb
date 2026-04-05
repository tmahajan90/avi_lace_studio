require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "valid user with all required attributes" do
    user = User.new(name: "Test User", email: "test@example.com", password: "password123")
    assert user.valid?
  end

  test "invalid without name" do
    user = User.new(email: "test@example.com", password: "password123")
    assert_not user.valid?
    assert_includes user.errors[:name], "can't be blank"
  end

  test "invalid without email" do
    user = User.new(name: "Test", password: "password123")
    assert_not user.valid?
  end

  test "invalid with duplicate email" do
    user = User.new(name: "Dup", email: users(:customer).email, password: "password123")
    assert_not user.valid?
  end

  test "default role is customer" do
    assert users(:customer).customer?
  end

  test "admin role is set correctly" do
    assert users(:admin).admin?
  end

  test "has many orders" do
    assert_respond_to users(:customer), :orders
  end

  test "has many addresses" do
    assert users(:customer).addresses.count >= 1
  end

  test "has one cart" do
    assert_respond_to users(:customer), :cart
  end

  test "destroying user destroys dependent associations" do
    user = users(:customer_two)
    uid  = user.id
    user.destroy
    assert_empty Order.where(user_id: uid)
    assert_empty Address.where(user_id: uid)
    assert_empty Wishlist.where(user_id: uid)
  end
end
