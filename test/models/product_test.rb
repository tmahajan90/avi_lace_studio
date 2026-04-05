require "test_helper"

class ProductTest < ActiveSupport::TestCase
  def valid_product_attrs
    {
      name: "Test Lace",
      price: 30.00,
      stock_quantity: 10,
      sku: "TL-001",
      category: categories(:cotton_laces),
      status: :active
    }
  end

  test "valid product" do
    assert Product.new(valid_product_attrs).valid?
  end

  test "invalid without name" do
    p = Product.new(valid_product_attrs.merge(name: nil))
    assert_not p.valid?
    assert_includes p.errors[:name], "can't be blank"
  end

  test "invalid without price" do
    p = Product.new(valid_product_attrs.merge(price: nil))
    assert_not p.valid?
  end

  test "invalid with negative price" do
    p = Product.new(valid_product_attrs.merge(price: -5))
    assert_not p.valid?
  end

  test "invalid with negative stock" do
    p = Product.new(valid_product_attrs.merge(stock_quantity: -1))
    assert_not p.valid?
  end

  test "slug auto-generated from name" do
    p = Product.new(valid_product_attrs)
    p.valid?
    assert_equal "test-lace", p.slug
  end

  test "invalid with duplicate slug" do
    p = Product.new(valid_product_attrs.merge(slug: products(:white_cotton_lace).slug))
    assert_not p.valid?
  end

  test "in_stock? returns true when stock > 0" do
    assert products(:white_cotton_lace).in_stock?
  end

  test "in_stock? returns false when stock is 0" do
    assert_not products(:out_of_stock_product).in_stock?
  end

  test "discounted? returns true when compare_price > price" do
    assert products(:white_cotton_lace).discounted?
  end

  test "discount_percentage calculates correctly" do
    p = products(:white_cotton_lace)
    expected = ((p.compare_price - p.price) / p.compare_price * 100).round
    assert_equal expected, p.discount_percentage
  end

  test "published scope returns only active products" do
    Product.published.each { |p| assert p.active? }
  end

  test "featured scope returns only featured products" do
    Product.featured.each { |p| assert p.featured? }
  end

  test "in_stock scope returns only products with stock > 0" do
    Product.in_stock.each { |p| assert p.stock_quantity > 0 }
  end
end
