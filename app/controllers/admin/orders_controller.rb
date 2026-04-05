module Admin
  class OrdersController < BaseController
    before_action :set_order, only: [:show, :update_status]

    def index
      @q = Order.includes(:user).ransack(params[:q])
      @orders = @q.result(distinct: true).order(created_at: :desc).page(params[:page]).per(20)
    end

    def show
      @order_items = @order.order_items.includes(:product)
    end

    def update_status
      if @order.update(status: params[:status])
        redirect_to admin_order_path(@order), notice: "Order status updated."
      else
        redirect_to admin_order_path(@order), alert: "Could not update status."
      end
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end
  end
end
