module Payments
  class RazorpayController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :verify_authenticity_token, only: [:verify]

    def verify
      order = current_user.orders.find_by(id: params[:order_id])
      return render json: { status: "failure", message: "Order not found" }, status: :not_found unless order

      result = RazorpayPaymentService.call(
        order:               order,
        cart:                current_cart,
        razorpay_order_id:   params[:razorpay_order_id],
        razorpay_payment_id: params[:razorpay_payment_id],
        razorpay_signature:  params[:razorpay_signature]
      )

      if result.success?
        render json: { status: "success", redirect_url: confirmation_order_path(result.payload) }
      else
        render json: { status: "failure", message: result.error }, status: :unprocessable_entity
      end
    end
  end
end
