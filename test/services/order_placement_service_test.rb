require "test_helper"

class OrderPlacementServiceTest < ActiveSupport::TestCase
  setup do
    @user    = users(:customer)
    @cart    = carts(:customer_cart)
    @address = addresses(:customer_home)
  end

  test "fails when cart is empty" do
    empty_cart = Cart.create!(user: @user, session_token: "empty_token_xyz")
    result = OrderPlacementService.call(
      user: @user, cart: empty_cart,
      shipping_address_id: @address.id,
      payment_method: "cod"
    )
    assert result.failure?
    assert_equal "Your cart is empty.", result.error
  end

  test "COD order succeeds and clears the cart" do
    # Use a separate cart with items
    cart = Cart.create!(user: @user, session_token: "cod_test_cart")
    cart.cart_items.create!(
      product: products(:floral_embroidered_trim),
      quantity: 1,
      price: 45.00
    )

    result = OrderPlacementService.call(
      user: @user, cart: cart,
      shipping_address_id: @address.id,
      payment_method: "cod"
    )

    assert result.success?
    assert_equal :cod, result.payload[:type]
    assert result.payload[:order].persisted?
    assert_equal 0, cart.reload.cart_items.count
  end

  test "COD order sets payment_method to cod" do
    cart = Cart.create!(user: @user, session_token: "cod_test_cart2")
    cart.cart_items.create!(
      product: products(:floral_embroidered_trim),
      quantity: 1,
      price: 45.00
    )

    result = OrderPlacementService.call(
      user: @user, cart: cart,
      shipping_address_id: @address.id,
      payment_method: "cod"
    )
    assert_equal "cod", result.payload[:order].payment_method
  end
end
