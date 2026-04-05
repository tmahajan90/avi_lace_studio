require "test_helper"

module Admin
  class OrdersControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "GET /admin/orders returns success" do
      get admin_orders_path
      assert_response :success
    end

    test "GET /admin/orders/:id returns order detail" do
      get admin_order_path(orders(:paid_order))
      assert_response :success
    end

    test "PATCH /admin/orders/:id/update_status updates order status" do
      patch update_status_admin_order_path(orders(:cod_order)), params: {
        order: { status: "processing" }
      }
      assert_response :redirect
    end

    test "non-admin cannot access admin orders" do
      sign_in_as users(:customer)
      get admin_orders_path
      assert_response :redirect
    end

    private

    def sign_in_as(user)
      post user_session_path, params: {
        user: { email: user.email, password: "password123" }
      }
    end
  end
end
