module Account
  class WishlistsController < BaseController
    def index
      @wishlist_items = current_user.wishlists.includes(:product)
    end

    def create
      product = Product.find(params[:product_id])
      result  = WishlistService::Add.call(user: current_user, product: product)

      redirect_back fallback_location: product_path(product),
                    notice: result.success? ? "Added to wishlist." : result.error
    end

    def destroy
      item   = current_user.wishlists.find(params[:id])
      WishlistService::Remove.call(user: current_user, wishlist_item: item)

      redirect_to account_wishlists_path, notice: "Removed from wishlist."
    end
  end
end
