# Verifies a Razorpay payment signature and confirms the order.
# On success: marks order paid, clears cart, sends confirmation email.
# On failure: cancels the order.
class RazorpayPaymentService < ApplicationService
  def initialize(order:, cart:, razorpay_order_id:, razorpay_payment_id:, razorpay_signature:)
    @order              = order
    @cart               = cart
    @razorpay_order_id  = razorpay_order_id
    @razorpay_payment_id = razorpay_payment_id
    @razorpay_signature = razorpay_signature
  end

  def call
    if valid_signature?
      confirm_order
      @cart.cart_items.destroy_all
      OrderMailer.confirmation(@order).deliver_later
      success(@order)
    else
      @order.update(status: :cancelled, payment_status: :unpaid)
      failure("Payment verification failed. Please contact support.")
    end
  end

  private

  def valid_signature?
    expected = OpenSSL::HMAC.hexdigest(
      "SHA256",
      ENV["RAZORPAY_KEY_SECRET"],
      "#{@razorpay_order_id}|#{@razorpay_payment_id}"
    )
    ActiveSupport::SecurityUtils.secure_compare(expected, @razorpay_signature)
  end

  def confirm_order
    @order.update!(
      razorpay_order_id:   @razorpay_order_id,
      razorpay_payment_id: @razorpay_payment_id,
      payment_status:      :paid,
      status:              :confirmed
    )
  end
end
