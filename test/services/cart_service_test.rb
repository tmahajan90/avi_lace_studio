require "test_helper"

class CartServiceTest < ActiveSupport::TestCase
  # --- CartService::Add ---
  test "Add returns success and creates new cart item" do
    cart    = carts(:customer_two_cart)
    product = products(:floral_embroidered_trim)
    result  = CartService::Add.call(cart: cart, product: product, quantity: 2)

    assert result.success?
    assert_equal product, result.payload.product
    assert_equal 2, result.payload.quantity
  end

  test "Add defaults quantity to 1 when zero given" do
    cart    = carts(:customer_two_cart)
    product = products(:floral_embroidered_trim)
    result  = CartService::Add.call(cart: cart, product: product, quantity: 0)

    assert result.success?
    assert_equal 1, result.payload.quantity
  end

  test "Add increments quantity for existing cart item" do
    cart    = carts(:customer_cart)
    product = products(:white_cotton_lace)
    item    = cart.cart_items.find_by!(product: product)
    old_qty = item.quantity

    CartService::Add.call(cart: cart, product: product, quantity: 3)
    assert_equal old_qty + 3, item.reload.quantity
  end

  # --- CartService::Update ---
  test "Update changes cart item quantity" do
    item   = cart_items(:customer_cart_item_one)
    cart   = item.cart
    result = CartService::Update.call(cart: cart, cart_item: item, quantity: 5)

    assert result.success?
    assert_equal 5, item.reload.quantity
  end

  test "Update with quantity 0 destroys the item" do
    item = cart_items(:customer_cart_item_two)
    cart = item.cart
    CartService::Update.call(cart: cart, cart_item: item, quantity: 0)
    assert_raises(ActiveRecord::RecordNotFound) { item.reload }
  end

  # --- CartService::Remove ---
  test "Remove destroys the cart item" do
    item = cart_items(:customer_cart_item_one)
    cart = item.cart
    result = CartService::Remove.call(cart: cart, cart_item: item)

    assert result.success?
    assert_raises(ActiveRecord::RecordNotFound) { item.reload }
  end
end
