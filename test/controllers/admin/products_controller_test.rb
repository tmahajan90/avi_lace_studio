require "test_helper"

module Admin
  class ProductsControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    # --- Index ---

    test "GET /admin/products returns success" do
      get admin_products_path
      assert_response :success
    end

    test "GET /admin/products search by name" do
      get admin_products_path, params: { "q[name_cont]" => "Cotton" }
      assert_response :success
    end

    test "GET /admin/products filter by category" do
      get admin_products_path, params: { category_id: categories(:laces).id }
      assert_response :success
    end

    test "GET /admin/products filter by subcategory" do
      get admin_products_path, params: { category_id: categories(:cotton_laces).id }
      assert_response :success
    end

    test "GET /admin/products filter by status active" do
      get admin_products_path, params: { status: "active" }
      assert_response :success
    end

    test "GET /admin/products filter by status draft" do
      get admin_products_path, params: { status: "draft" }
      assert_response :success
    end

    test "GET /admin/products sort by name_asc" do
      get admin_products_path, params: { sort: "name_asc" }
      assert_response :success
    end

    test "GET /admin/products sort by price_desc" do
      get admin_products_path, params: { sort: "price_desc" }
      assert_response :success
    end

    test "GET /admin/products sort by stock_asc" do
      get admin_products_path, params: { sort: "stock_asc" }
      assert_response :success
    end

    test "GET /admin/products sort by category" do
      get admin_products_path, params: { sort: "category" }
      assert_response :success
    end

    # --- New / Create ---

    test "GET /admin/products/new returns success" do
      get new_admin_product_path
      assert_response :success
    end

    test "POST /admin/products creates product" do
      assert_difference "Product.count", 1 do
        post admin_products_path, params: {
          product: {
            name: "New Test Product",
            price: 40.00,
            stock_quantity: 20,
            sku: "NTP-001",
            category_id: categories(:cotton_laces).id,
            status: "active"
          }
        }
      end
      assert_redirected_to admin_products_path
    end

    test "POST /admin/products with invalid params renders new" do
      assert_no_difference "Product.count" do
        post admin_products_path, params: {
          product: { name: "", price: -1, sku: "", category_id: categories(:cotton_laces).id }
        }
      end
      assert_response :unprocessable_entity
    end

    # --- Edit / Update ---

    test "GET /admin/products/:id/edit returns success" do
      get edit_admin_product_path(products(:white_cotton_lace))
      assert_response :success
    end

    test "PATCH /admin/products/:id updates product" do
      patch admin_product_path(products(:white_cotton_lace)), params: {
        product: { name: "Updated Lace Name" }
      }
      assert_redirected_to admin_products_path
      assert_equal "Updated Lace Name", products(:white_cotton_lace).reload.name
    end

    test "PATCH /admin/products/:id with invalid params renders edit" do
      patch admin_product_path(products(:white_cotton_lace)), params: {
        product: { name: "", price: -5 }
      }
      assert_response :unprocessable_entity
    end

    # --- Delete ---

    test "DELETE /admin/products/:id deletes product" do
      assert_difference "Product.count", -1 do
        delete admin_product_path(products(:gold_silk_lace))
      end
      assert_redirected_to admin_products_path
    end

    # --- update_stock ---

    test "PATCH update_stock with valid quantity updates stock" do
      product = products(:white_cotton_lace)
      patch update_stock_admin_product_path(product),
            params: { stock_quantity: 42 },
            as: :json,
            headers: { "X-CSRF-Token" => "test" }
      assert_response :success
      assert_equal 42, product.reload.stock_quantity
    end

    test "PATCH update_stock with negative quantity returns error" do
      product = products(:white_cotton_lace)
      patch update_stock_admin_product_path(product),
            params: { stock_quantity: -5 },
            as: :json
      assert_response :unprocessable_entity
    end

    test "PATCH update_stock returns json with updated stock" do
      product = products(:white_cotton_lace)
      patch update_stock_admin_product_path(product),
            params: { stock_quantity: 99 },
            as: :json
      json = JSON.parse(response.body)
      assert_equal 99, json["stock_quantity"]
    end

    # --- Access control ---

    test "non-admin user cannot access admin products" do
      sign_in_as users(:customer)
      get admin_products_path
      assert_response :redirect
    end

    test "unauthenticated user cannot access admin products" do
      delete user_session_path
      get admin_products_path
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
