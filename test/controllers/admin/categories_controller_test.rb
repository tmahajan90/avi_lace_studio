require "test_helper"

module Admin
  class CategoriesControllerTest < ActionDispatch::IntegrationTest
    setup do
      sign_in_as users(:admin)
    end

    test "GET /admin/categories returns success" do
      get admin_categories_path
      assert_response :success
    end

    test "GET /admin/categories/new returns success" do
      get new_admin_category_path
      assert_response :success
    end

    test "POST /admin/categories creates root category" do
      assert_difference "Category.count", 1 do
        post admin_categories_path, params: {
          category: { name: "New Root Category", slug: "new-root-category" }
        }
      end
      assert_redirected_to admin_categories_path
    end

    test "POST /admin/categories creates subcategory with parent" do
      assert_difference "Category.count", 1 do
        post admin_categories_path, params: {
          category: {
            name: "New Sub Category",
            slug: "new-sub-category",
            parent_id: categories(:laces).id
          }
        }
      end
      new_cat = Category.find_by(slug: "new-sub-category")
      assert_equal categories(:laces).id, new_cat.parent_id
    end

    test "POST /admin/categories with duplicate slug renders new" do
      assert_no_difference "Category.count" do
        post admin_categories_path, params: {
          category: { name: "Laces", slug: "laces" }
        }
      end
      assert_response :unprocessable_entity
    end

    test "GET /admin/categories/:id/edit returns success" do
      get edit_admin_category_path(categories(:laces))
      assert_response :success
    end

    test "PATCH /admin/categories/:id updates category" do
      patch admin_category_path(categories(:beaded_laces)), params: {
        category: { description: "Updated beaded lace description" }
      }
      assert_redirected_to admin_categories_path
      assert_equal "Updated beaded lace description", categories(:beaded_laces).reload.description
    end

    test "DELETE /admin/categories/:id deletes category" do
      cat = Category.create!(name: "Deletable Cat", slug: "deletable-cat")
      assert_difference "Category.count", -1 do
        delete admin_category_path(cat)
      end
    end

    test "non-admin cannot access admin categories" do
      sign_in_as users(:customer)
      get admin_categories_path
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
