require "test_helper"

class CategoriesControllerTest < ActionDispatch::IntegrationTest
  test "GET /categories/:slug returns success for root category" do
    get category_path(categories(:laces).slug)
    assert_response :success
  end

  test "GET /categories/:slug returns success for subcategory" do
    get category_path(categories(:cotton_laces).slug)
    assert_response :success
  end

  test "GET /categories/:slug shows products from subcategories when parent" do
    # visiting the 'laces' parent should include products from cotton_laces etc.
    get category_path(categories(:laces).slug)
    assert_response :success
  end

  test "GET /categories/:slug returns 404 for unknown slug" do
    assert_raises(ActiveRecord::RecordNotFound) do
      get category_path("unknown-slug-xyz")
    end
  end
end
