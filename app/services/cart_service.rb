# Manages cart operations: add, update quantity, remove items.
class CartService < ApplicationService
  def initialize(cart:, product: nil, cart_item: nil, quantity: nil)
    @cart      = cart
    @product   = product
    @cart_item = cart_item
    @quantity  = quantity
  end

  def call
    raise NotImplementedError, "Use CartService::Add, Update, or Remove directly"
  end

  class Add < ApplicationService
    def initialize(cart:, product:, quantity: 1)
      @cart     = cart
      @product  = product
      @quantity = [quantity.to_i, 1].max
    end

    def call
      item = @cart.add_product(@product, @quantity)
      item.persisted? ? success(item) : failure(item.errors.full_messages.join(", "))
    end
  end

  class Update < ApplicationService
    def initialize(cart:, cart_item:, quantity:)
      @cart      = cart
      @cart_item = cart_item
      @quantity  = quantity.to_i
    end

    def call
      if @quantity > 0
        @cart_item.update(quantity: @quantity) ? success(@cart_item) : failure("Could not update quantity.")
      else
        @cart_item.destroy
        success(nil)
      end
    end
  end

  class Remove < ApplicationService
    def initialize(cart:, cart_item:)
      @cart      = cart
      @cart_item = cart_item
    end

    def call
      @cart_item.destroy
      success(nil)
    end
  end
end
