require "test_helper"

class CategoryTest < ActiveSupport::TestCase
  test "valid category" do
    cat = Category.new(name: "New Category", slug: "new-category")
    assert cat.valid?
  end

  test "invalid without name" do
    cat = Category.new(slug: "no-name")
    assert_not cat.valid?
    assert_includes cat.errors[:name], "can't be blank"
  end

  test "slug is auto-generated from name" do
    cat = Category.new(name: "My New Category")
    cat.valid?
    assert_equal "my-new-category", cat.slug
  end

  test "invalid with duplicate slug" do
    cat = Category.new(name: "Cotton Laces", slug: categories(:cotton_laces).slug)
    assert_not cat.valid?
    assert_includes cat.errors[:slug], "has already been taken"
  end

  test "has many products" do
    assert_respond_to categories(:cotton_laces), :products
  end

  test "root_categories scope excludes subcategories" do
    root_cats = Category.root_categories
    assert root_cats.all? { |c| c.parent_id.nil? }
  end
end
