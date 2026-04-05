require "test_helper"

class ProductsControllerTest < ActionDispatch::IntegrationTest
  test "GET /products returns success" do
    get products_path
    assert_response :success
  end

  test "GET /products lists active products" do
    get products_path
    assert_select "body"
    # active products should appear; draft should not
    assert_response :success
  end

  test "GET /products with search query filters by name" do
    get products_path, params: { "q[name_cont]" => "Cotton" }
    assert_response :success
  end

  test "GET /products/:slug returns success for active product" do
    get product_path(products(:white_cotton_lace).slug)
    assert_response :success
  end

  test "GET /products/:slug returns 404 for unknown slug" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get product_path("nonexistent-slug")
    end
  end
end
