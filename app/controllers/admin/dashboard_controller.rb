module Admin
  class DashboardController < BaseController
    def index
      data = AdminDashboardService.call.payload
      @total_orders       = data[:total_orders]
      @pending_orders     = data[:pending_orders]
      @total_revenue      = data[:total_revenue]
      @total_products     = data[:total_products]
      @recent_orders      = data[:recent_orders]
      @low_stock_products = data[:low_stock_products]
    end
  end
end
