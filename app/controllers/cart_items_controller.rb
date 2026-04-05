class CartItemsController < ApplicationController
  before_action :set_cart

  def create
    product = Product.find(params[:product_id])
    result  = CartService::Add.call(cart: @cart, product: product, quantity: params[:quantity])

    redirect_to cart_path, notice: result.success? ? "#{product.name} added to cart." : result.error
  end

  def update
    item   = @cart.cart_items.find(params[:id])
    result = CartService::Update.call(cart: @cart, cart_item: item, quantity: params.dig(:cart_item, :quantity))

    redirect_to cart_path
  end

  def destroy
    item = @cart.cart_items.find(params[:id])
    CartService::Remove.call(cart: @cart, cart_item: item)

    redirect_to cart_path, notice: "Item removed from cart."
  end

  private

  def set_cart
    @cart = current_cart
  end
end
