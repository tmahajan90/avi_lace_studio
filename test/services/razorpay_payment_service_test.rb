require "test_helper"

class RazorpayPaymentServiceTest < ActiveSupport::TestCase
  setup do
    @order = orders(:paid_order)
    @cart  = carts(:customer_cart)
    @key_secret = ENV.fetch("RAZORPAY_KEY_SECRET", "thisissecret")
  end

  def valid_signature(order_id, payment_id)
    OpenSSL::HMAC.hexdigest("SHA256", @key_secret, "#{order_id}|#{payment_id}")
  end

  test "succeeds with valid signature and confirms order" do
    order_id   = "order_test_valid"
    payment_id = "pay_test_valid"
    sig        = valid_signature(order_id, payment_id)

    @order.update!(status: :pending, payment_status: :unpaid)

    result = RazorpayPaymentService.call(
      order: @order, cart: @cart,
      razorpay_order_id: order_id,
      razorpay_payment_id: payment_id,
      razorpay_signature: sig
    )

    assert result.success?
    assert @order.reload.payment_paid?
    assert @order.reload.confirmed?
  end

  test "fails with invalid signature and cancels order" do
    @order.update!(status: :pending, payment_status: :unpaid)

    result = RazorpayPaymentService.call(
      order: @order, cart: @cart,
      razorpay_order_id: "order_bad",
      razorpay_payment_id: "pay_bad",
      razorpay_signature: "wrong_signature"
    )

    assert result.failure?
    assert_includes result.error, "Payment verification failed"
    assert @order.reload.cancelled?
  end
end
