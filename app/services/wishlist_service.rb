# Manages wishlist add/remove for a user.
class WishlistService < ApplicationService
  class Add < ApplicationService
    def initialize(user:, product:)
      @user    = user
      @product = product
    end

    def call
      return success(nil) if @user.wishlists.exists?(product: @product)

      item = @user.wishlists.create(product: @product)
      item.persisted? ? success(item) : failure(item.errors.full_messages.join(", "))
    end
  end

  class Remove < ApplicationService
    def initialize(user:, wishlist_item:)
      @user          = user
      @wishlist_item = wishlist_item
    end

    def call
      @wishlist_item.destroy
      success(nil)
    end
  end
end
