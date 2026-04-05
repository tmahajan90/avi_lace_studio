class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.order(created_at: :desc).page(params[:page]).per(10)
  end

  def show
    @order = current_user.orders.find_by!(order_number: params[:id])
    redirect_to account_order_path(@order)
  end

  def checkout
    @cart = current_cart
    redirect_to cart_path, alert: "Your cart is empty." and return if @cart.cart_items.empty?
    @addresses = current_user.addresses
  end

  def place
    result = OrderPlacementService.call(
      user:                current_user,
      cart:                current_cart,
      shipping_address_id: params.dig(:order, :shipping_address_id),
      payment_method:      params[:payment_method] || "razorpay",
      notes:               params.dig(:order, :notes)
    )

    if result.success?
      render json: build_place_response(result.payload)
    else
      render json: { errors: [result.error] }, status: :unprocessable_entity
    end
  end

  def confirmation
    @order = current_user.orders.find_by!(order_number: params[:id])
  end

  private

  def build_place_response(payload)
    if payload[:type] == :cod
      { order_number: payload[:order].order_number, redirect_url: confirmation_order_path(payload[:order]) }
    else
      order = payload[:order]
      {
        order_id:          order.id,
        order_number:      order.order_number,
        amount:            payload[:amount],
        currency:          payload[:currency],
        razorpay_key:      payload[:razorpay_key],
        razorpay_order_id: payload[:razorpay_order_id],
        customer_name:     current_user.name,
        customer_email:    current_user.email,
        customer_phone:    current_user.phone.to_s
      }
    end
  end
end
