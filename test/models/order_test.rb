require "test_helper"

class OrderTest < ActiveSupport::TestCase
  test "order number is set on paid_order fixture" do
    order = orders(:paid_order)
    assert order.order_number.present?
  end

  test "status enum works" do
    order = orders(:paid_order)
    assert order.confirmed?
  end

  test "payment_status enum works" do
    order = orders(:paid_order)
    assert order.payment_paid?
  end

  test "cod order is pending and unpaid" do
    order = orders(:cod_order)
    assert order.pending?
    assert order.payment_unpaid?
  end

  test "invalid with negative total_amount" do
    order = orders(:paid_order)
    order.total_amount = -10
    assert_not order.valid?
  end

  test "belongs to user" do
    assert_equal users(:customer), orders(:paid_order).user
  end

  test "has many order_items" do
    assert orders(:paid_order).order_items.count >= 1
  end

  test "build_from_cart populates order_items and totals" do
    cart   = carts(:customer_cart)
    order  = Order.new(user: users(:customer))
    order.build_from_cart(cart)
    assert_equal cart.cart_items.count, order.order_items.size
    assert_equal cart.total, order.subtotal
  end

  test "generate_order_number produces expected prefix" do
    order = Order.create!(
      user: users(:admin),
      total_amount: 50,
      payment_method: "cod"
    )
    assert_match(/\AALS-\d{8}-[A-F0-9]{6}\z/, order.order_number)
  end
end
