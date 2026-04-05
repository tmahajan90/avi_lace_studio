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

  # --- Validations ---

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

  test "price of zero is valid" do
    p = Product.new(valid_product_attrs.merge(price: 0))
    assert p.valid?
  end

  test "invalid with negative stock" do
    p = Product.new(valid_product_attrs.merge(stock_quantity: -1))
    assert_not p.valid?
  end

  test "stock of zero is valid" do
    p = Product.new(valid_product_attrs.merge(stock_quantity: 0))
    assert p.valid?
  end

  # --- Slug ---

  test "slug auto-generated from name" do
    p = Product.new(valid_product_attrs)
    p.valid?
    assert_equal "test-lace", p.slug
  end

  test "invalid with duplicate slug" do
    p = Product.new(valid_product_attrs.merge(slug: products(:white_cotton_lace).slug))
    assert_not p.valid?
  end

  # --- Scopes ---

  test "published scope returns only active products" do
    Product.published.each { |p| assert p.active? }
  end

  test "published scope excludes draft products" do
    assert_not_includes Product.published.map(&:slug), products(:draft_product).slug
  end

  test "featured scope returns only featured products" do
    Product.featured.each { |p| assert p.featured? }
  end

  test "in_stock scope returns only products with stock > 0" do
    Product.in_stock.each { |p| assert p.stock_quantity > 0 }
  end

  test "in_stock scope excludes out-of-stock products" do
    assert_not_includes Product.in_stock.map(&:id), products(:out_of_stock_product).id
  end

  # --- Instance methods ---

  test "in_stock? returns true when stock > 0" do
    assert products(:white_cotton_lace).in_stock?
  end

  test "in_stock? returns false when stock is 0" do
    assert_not products(:out_of_stock_product).in_stock?
  end

  test "discounted? returns true when compare_price > price" do
    assert products(:white_cotton_lace).discounted?
  end

  test "discounted? returns false when compare_price is nil" do
    p = Product.new(valid_product_attrs.merge(compare_price: nil))
    assert_not p.discounted?
  end

  test "discounted? returns false when compare_price equals price" do
    p = Product.new(valid_product_attrs.merge(price: 30, compare_price: 30))
    assert_not p.discounted?
  end

  test "discount_percentage calculates correctly" do
    p = products(:white_cotton_lace)
    expected = ((p.compare_price - p.price) / p.compare_price * 100).round
    assert_equal expected, p.discount_percentage
  end

  test "discount_percentage returns 0 when not discounted" do
    p = Product.new(valid_product_attrs.merge(compare_price: nil))
    assert_equal 0, p.discount_percentage
  end

  # --- image_url ---

  test "image_url returns nil when cloudinary_url is blank" do
    p = products(:white_cotton_lace)
    p.cloudinary_url = nil
    assert_nil p.image_url
  end

  test "image_url returns cloudinary_url when present" do
    p = products(:white_cotton_lace)
    p.cloudinary_url = "https://res.cloudinary.com/test/image/upload/sample.jpg"
    assert_equal "https://res.cloudinary.com/test/image/upload/sample.jpg", p.image_url
  end

  # --- cloudinary_folder ---

  test "cloudinary_folder returns subcategory path when product has subcategory" do
    p = products(:white_cotton_lace)
    # cotton_laces has parent: laces
    assert_equal "avi_lace_studio/laces/cotton_laces", p.cloudinary_folder
  end

  test "cloudinary_folder returns root category path when no parent" do
    p = products(:white_cotton_lace)
    p.category = categories(:laces)
    assert_equal "avi_lace_studio/laces", p.cloudinary_folder
  end

  test "cloudinary_folder returns default when no category" do
    p = Product.new(valid_product_attrs)
    p.category = nil
    assert_equal "avi_lace_studio/products", p.cloudinary_folder
  end

  # --- Associations ---

  test "belongs to category" do
    assert_equal categories(:cotton_laces), products(:white_cotton_lace).category
  end

  test "has many product_images" do
    assert_respond_to products(:white_cotton_lace), :product_images
  end

  test "status enum values are correct" do
    p = Product.new(valid_product_attrs.merge(status: :draft))
    assert p.draft?

    p.status = :active
    assert p.active?

    p.status = :archived
    assert p.archived?
  end
end
