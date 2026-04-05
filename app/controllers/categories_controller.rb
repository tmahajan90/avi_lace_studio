class CategoriesController < ApplicationController
  def show
    @category = Category.find_by!(slug: params[:id])
    @products = @category.products.published.includes(:product_images).page(params[:page]).per(12)
  end
end
