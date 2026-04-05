require "test_helper"

module Admin
  class DashboardControllerTest < ActionDispatch::IntegrationTest
    test "GET /admin redirects unauthenticated user" do
      get admin_root_path
      assert_response :redirect
    end

    test "GET /admin redirects non-admin user" do
      post user_session_path, params: {
        user: { email: users(:customer).email, password: "password123" }
      }
      get admin_root_path
      assert_response :redirect
    end

    test "GET /admin returns success for admin user" do
      post user_session_path, params: {
        user: { email: users(:admin).email, password: "password123" }
      }
      get admin_root_path
      assert_response :success
    end
  end
end
