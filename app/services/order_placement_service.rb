# Handles the full order placement flow:
#   - Validates cart is not empty
#   - Builds and persists the order from the cart
#   - For COD: clears cart, sends confirmation email
#   - For Razorpay: creates a Razorpay order, returns payment data for the JS popup
class OrderPlacementService < ApplicationService
  def initialize(user:, cart:, shipping_address_id:, payment_method:, notes: nil)
    @user               = user
    @cart               = cart
    @shipping_address_id = shipping_address_id
    @payment_method     = payment_method
    @notes              = notes
  end

  def call
    return failure("Your cart is empty.") if @cart.cart_items.empty?

    order = build_order
    return failure(order.errors.full_messages.join(", ")) unless order.save

    if cod?
      handle_cod(order)
    else
      handle_razorpay(order)
    end
  end

  private

  def build_order
    order = @user.orders.build(
      shipping_address_id: @shipping_address_id,
      notes:               @notes,
      payment_method:      @payment_method
    )
    order.build_from_cart(@cart)
    order
  end

  def cod?(method = @payment_method)
    method == "cod"
  end

  def handle_cod(order)
    @cart.cart_items.destroy_all
    OrderMailer.confirmation(order).deliver_later
    success({ type: :cod, order: order })
  end

  def handle_razorpay(order)
    razorpay_order = Razorpay::Order.create(
      amount:   (order.total_amount * 100).to_i,
      currency: "INR",
      receipt:  order.order_number
    )
    order.update!(razorpay_order_id: razorpay_order.id)

    success({
      type:              :razorpay,
      order:             order,
      razorpay_order_id: razorpay_order.id,
      amount:            (order.total_amount * 100).to_i,
      currency:          "INR",
      razorpay_key:      ENV["RAZORPAY_KEY_ID"]
    })
  rescue Razorpay::Error => e
    order.destroy
    failure("Payment gateway error: #{e.message}")
  end
end
