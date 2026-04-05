class ProductsController < ApplicationController
  def index
    result     = ProductSearchService.call(params: params)
    @q         = result.payload[:ransack_query]
    @products  = result.payload[:products]
    @categories          = Category.root_categories
    @current_category    = Category.find_by(id: params[:category_id]) if params[:category_id].present?
  end

  def show
    @product         = Product.published.find_by!(slug: params[:id])
    @related_products = Product.published
                               .where(category: @product.category)
                               .where.not(id: @product.id)
                               .limit(4)
  end
end
