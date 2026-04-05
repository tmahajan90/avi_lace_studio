class CategoriesController < ApplicationController
  def show
    @category  = Category.find_by!(slug: params[:id])
    @root_cats = Category.root_categories.includes(:subcategories)

    # If this is a parent category, show products from all subcategories too
    category_ids = if @category.subcategories.any?
      [@category.id] + @category.subcategories.pluck(:id)
    else
      [@category.id]
    end

    @products = Product.published
                       .where(category_id: category_ids)
                       .includes(:product_images)
                       .page(params[:page]).per(12)
  end
end
