require "test_helper"

class WishlistTest < ActiveSupport::TestCase
  test "valid wishlist item" do
    assert wishlists(:customer_wishlist_item).valid?
  end

  test "belongs to user" do
    assert_equal users(:customer), wishlists(:customer_wishlist_item).user
  end

  test "belongs to product" do
    assert_equal products(:gold_silk_lace), wishlists(:customer_wishlist_item).product
  end

  test "user can have multiple wishlist items" do
    assert users(:customer).wishlists.count >= 2
  end
end
