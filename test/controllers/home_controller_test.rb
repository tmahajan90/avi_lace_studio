require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "GET / returns success" do
    get root_path
    assert_response :success
  end

  test "GET / renders the home page" do
    get root_path
    assert_select "body"
  end
end
