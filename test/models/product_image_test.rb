require "test_helper"

class ProductImageTest < ActiveSupport::TestCase
  test "fixture product images are valid" do
    assert product_images(:one).valid?
    assert product_images(:two).valid?
  end

  test "belongs to product" do
    assert_equal products(:white_cotton_lace), product_images(:one).product
  end

  test "image_url returns cloudinary_url when present" do
    img = product_images(:one)
    img.cloudinary_url = "https://res.cloudinary.com/test/image/upload/sample.jpg"
    assert_equal "https://res.cloudinary.com/test/image/upload/sample.jpg", img.image_url
  end

  test "image_url returns nil when cloudinary_url is blank and no attachment" do
    img = product_images(:one)
    img.cloudinary_url = nil
    # no file attached in test fixtures
    result = img.image_url
    assert_nil result
  end

  test "destroying product destroys product images" do
    # Use a product with no order items to avoid null constraint
    product = Product.create!(
      name: "Temp Product For Delete",
      slug: "temp-product-for-delete",
      price: 10,
      stock_quantity: 5,
      sku: "TPD-001",
      category: categories(:cotton_laces),
      status: :active
    )
    img = ProductImage.create!(product: product, position: 1, cloudinary_url: "https://res.cloudinary.com/demo/sample.jpg")
    img_id = img.id
    product.destroy
    assert_nil ProductImage.find_by(id: img_id)
  end
end
