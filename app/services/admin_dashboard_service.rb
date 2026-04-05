# Aggregates all data needed for the admin dashboard in one place.
class AdminDashboardService < ApplicationService
  def call
    success({
      total_orders:       Order.count,
      pending_orders:     Order.pending.count,
      total_revenue:      Order.where(payment_status: :paid).sum(:total_amount),
      total_products:     Product.active.count,
      recent_orders:      Order.includes(:user).order(created_at: :desc).limit(10),
      low_stock_products: Product.active.where("stock_quantity <= 5").limit(10)
    })
  end
end
