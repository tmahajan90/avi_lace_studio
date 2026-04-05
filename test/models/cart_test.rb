require "test_helper"

class CartTest < ActiveSupport::TestCase
  test "belongs to user (optional)" do
    cart = carts(:customer_cart)
    assert_equal users(:customer), cart.user
  end

  test "can exist without a user (guest cart)" do
    cart = Cart.new(session_token: "guest_token_123")
    assert cart.valid?
  end

  test "has many cart_items" do
    cart = carts(:customer_cart)
    assert cart.cart_items.count >= 1
  end

  test "total sums item quantities * price" do
    cart = carts(:customer_cart)
    expected = cart.cart_items.sum { |i| i.quantity * i.price }
    assert_equal expected, cart.total
  end

  test "item_count sums all quantities" do
    cart = carts(:customer_cart)
    expected = cart.cart_items.sum(:quantity)
    assert_equal expected, cart.item_count
  end

  test "add_product adds new item to cart" do
    cart = carts(:customer_two_cart)
    product = products(:floral_embroidered_trim)
    assert_difference "cart.cart_items.count", 1 do
      cart.add_product(product)
    end
  end

  test "add_product increments quantity for existing item" do
    cart    = carts(:customer_cart)
    product = products(:white_cotton_lace)
    item    = cart.cart_items.find_by(product: product)
    old_qty = item.quantity
    cart.add_product(product, 2)
    assert_equal old_qty + 2, item.reload.quantity
  end
end
