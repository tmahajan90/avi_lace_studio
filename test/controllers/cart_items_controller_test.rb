require "test_helper"

class CartItemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:customer)
  end

  test "POST /cart/cart_items adds item to cart" do
    product = products(:beaded_lace_product)
    assert_difference "CartItem.count", 1 do
      post cart_cart_items_path, params: { product_id: product.id, quantity: 1 }
    end
    assert_response :redirect
  end

  test "POST /cart/cart_items does not add out-of-stock product" do
    product = products(:out_of_stock_product)
    assert_no_difference "CartItem.count" do
      post cart_cart_items_path, params: { product_id: product.id, quantity: 1 }
    end
  end

  test "DELETE /cart/cart_items/:id removes item from cart" do
    # Add item first
    product = products(:beaded_lace_product)
    post cart_cart_items_path, params: { product_id: product.id, quantity: 1 }
    item = CartItem.last
    assert_difference "CartItem.count", -1 do
      delete cart_cart_item_path(item)
    end
  end

  private

  def sign_in_as(user)
    post user_session_path, params: {
      user: { email: user.email, password: "password123" }
    }
  end
end
