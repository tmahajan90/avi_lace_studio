require "test_helper"

class AdminDashboardServiceTest < ActiveSupport::TestCase
  test "returns success with all required keys" do
    result = AdminDashboardService.call
    assert result.success?
    %i[total_orders pending_orders total_revenue total_products recent_orders low_stock_products].each do |key|
      assert result.payload.key?(key), "Missing key: #{key}"
    end
  end

  test "total_orders count is non-negative" do
    assert AdminDashboardService.call.payload[:total_orders] >= 0
  end

  test "total_revenue is non-negative" do
    assert AdminDashboardService.call.payload[:total_revenue] >= 0
  end
end
