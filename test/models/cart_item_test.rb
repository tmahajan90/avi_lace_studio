require "test_helper"

class CartItemTest < ActiveSupport::TestCase
  test "valid cart item" do
    item = cart_items(:customer_cart_item_one)
    assert item.valid?
  end

  test "invalid with quantity zero" do
    item = cart_items(:customer_cart_item_one)
    item.quantity = 0
    assert_not item.valid?
    assert_includes item.errors[:quantity], "must be greater than 0"
  end

  test "invalid with negative price" do
    item = cart_items(:customer_cart_item_one)
    item.price = -1
    assert_not item.valid?
  end

  test "subtotal returns quantity * price" do
    item = cart_items(:customer_cart_item_one)
    assert_equal item.quantity * item.price, item.subtotal
  end
end
