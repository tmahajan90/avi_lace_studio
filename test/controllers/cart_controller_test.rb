require "test_helper"

class CartControllerTest < ActionDispatch::IntegrationTest
  test "GET /cart returns success" do
    get cart_path
    assert_response :success
  end

  test "GET /cart as signed-in user returns success" do
    sign_in_as users(:customer)
    get cart_path
    assert_response :success
  end

  private

  def sign_in_as(user)
    post user_session_path, params: {
      user: { email: user.email, password: "password123" }
    }
  end
end
