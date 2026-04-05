require "test_helper"

class ProductSearchServiceTest < ActiveSupport::TestCase
  test "returns success with products and ransack_query" do
    result = ProductSearchService.call(params: {})
    assert result.success?
    assert_respond_to result.payload[:products], :each
    assert result.payload[:ransack_query].present?
  end

  test "filters by category_id" do
    category = categories(:cotton_laces)
    result   = ProductSearchService.call(params: { category_id: category.id })

    assert result.success?
    result.payload[:products].each do |p|
      assert_equal category.id, p.category_id
    end
  end

  test "filters by min_price" do
    result = ProductSearchService.call(params: { min_price: "50" })
    assert result.success?
    result.payload[:products].each do |p|
      assert p.price >= 50
    end
  end

  test "filters by max_price" do
    result = ProductSearchService.call(params: { max_price: "40" })
    assert result.success?
    result.payload[:products].each do |p|
      assert p.price <= 40
    end
  end

  test "only returns active (published) products" do
    result = ProductSearchService.call(params: {})
    assert result.success?
    result.payload[:products].each do |p|
      assert p.active?
    end
  end
end
