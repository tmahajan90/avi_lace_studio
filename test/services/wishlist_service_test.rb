require "test_helper"

class WishlistServiceTest < ActiveSupport::TestCase
  test "Add creates wishlist item for a product not already wishlisted" do
    user    = users(:customer)
    product = products(:white_cotton_lace)
    # Make sure it is not in the wishlist
    user.wishlists.where(product: product).destroy_all

    result = WishlistService::Add.call(user: user, product: product)
    assert result.success?
    assert user.wishlists.exists?(product: product)
  end

  test "Add returns success without duplicating if already in wishlist" do
    user    = users(:customer)
    product = products(:gold_silk_lace) # already in customer's wishlist
    count_before = user.wishlists.count

    result = WishlistService::Add.call(user: user, product: product)
    assert result.success?
    assert_equal count_before, user.wishlists.count
  end

  test "Remove destroys the wishlist item" do
    item   = wishlists(:customer_wishlist_item)
    user   = item.user
    result = WishlistService::Remove.call(user: user, wishlist_item: item)

    assert result.success?
    assert_raises(ActiveRecord::RecordNotFound) { item.reload }
  end
end
