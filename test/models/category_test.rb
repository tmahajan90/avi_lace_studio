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
    cat = Category.new(name: "Cotton Laces Dup", slug: categories(:cotton_laces).slug)
    assert_not cat.valid?
    assert_includes cat.errors[:slug], "has already been taken"
  end

  test "has many products" do
    assert_respond_to categories(:cotton_laces), :products
  end

  test "root_categories scope returns only root categories" do
    root_cats = Category.root_categories
    assert root_cats.any?
    assert root_cats.all? { |c| c.parent_id.nil? }
  end

  test "root_categories does not include subcategories" do
    root_cat_slugs = Category.root_categories.map(&:slug)
    assert_not_includes root_cat_slugs, "cotton-laces"
    assert_not_includes root_cat_slugs, "silk-laces"
  end

  test "root categories include top-level categories" do
    slugs = Category.root_categories.map(&:slug)
    assert_includes slugs, "laces"
    assert_includes slugs, "buttons"
  end

  test "subcategories association returns children" do
    laces = categories(:laces)
    sub_names = laces.subcategories.map(&:name)
    assert_includes sub_names, "Cotton Laces"
    assert_includes sub_names, "Silk Laces"
  end

  test "parent association returns parent category" do
    cotton = categories(:cotton_laces)
    assert_equal categories(:laces).id, cotton.parent.id
  end

  test "root category has no parent" do
    assert_nil categories(:laces).parent
  end

  test "subcategory parent_id is set" do
    assert_equal categories(:laces).id, categories(:cotton_laces).parent_id
  end

  test "destroying parent destroys subcategories" do
    parent = Category.create!(name: "Temp Parent XYZ", slug: "temp-parent-xyz")
    child  = Category.create!(name: "Temp Child XYZ", slug: "temp-child-xyz", parent: parent)
    child_id = child.id
    parent.destroy
    assert_nil Category.find_by(id: child_id)
  end
end
