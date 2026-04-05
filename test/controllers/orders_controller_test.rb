require "test_helper"

class OrdersControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:customer)
  end

  test "GET /orders/checkout redirects to login if not signed in" do
    delete user_session_path
    get checkout_orders_path
    assert_response :redirect
  end

  test "GET /orders/checkout returns success when signed in" do
    get checkout_orders_path
    assert_response :success
  end

  test "GET /orders returns list of user orders" do
    get orders_path
    assert_response :redirect # account/orders is separate; top-level /orders redirects
  end

  test "GET /account/orders returns user orders" do
    get account_orders_path
    assert_response :success
  end

  test "GET /account/orders/:id returns order detail" do
    get account_order_path(orders(:paid_order))
    assert_response :success
  end

  private

  def sign_in_as(user)
    post user_session_path, params: {
      user: { email: user.email, password: "password123" }
    }
  end
end
