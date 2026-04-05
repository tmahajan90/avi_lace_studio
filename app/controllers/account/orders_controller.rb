module Account
  class OrdersController < BaseController
    def index
      @orders = current_user.orders.includes(:order_items).order(created_at: :desc).page(params[:page]).per(10)
    end

    def show
      @order = current_user.orders.includes(:order_items).find_by!(order_number: params[:id])
    rescue ActiveRecord::RecordNotFound
      redirect_to account_orders_path, alert: "Order not found."
    end
  end
end
