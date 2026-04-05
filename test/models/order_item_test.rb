require "test_helper"

class OrderItemTest < ActiveSupport::TestCase
  test "valid order item" do
    assert order_items(:paid_order_item_one).valid?
  end

  test "invalid without product_name" do
    item = order_items(:paid_order_item_one)
    item.product_name = nil
    assert_not item.valid?
    assert_includes item.errors[:product_name], "can't be blank"
  end

  test "invalid with quantity zero" do
    item = order_items(:paid_order_item_one)
    item.quantity = 0
    assert_not item.valid?
    assert_includes item.errors[:quantity], "must be greater than 0"
  end

  test "invalid with negative unit_price" do
    item = order_items(:paid_order_item_one)
    item.unit_price = -1
    assert_not item.valid?
  end

  test "belongs to order" do
    assert_equal orders(:paid_order), order_items(:paid_order_item_one).order
  end
end
