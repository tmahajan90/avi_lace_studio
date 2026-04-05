class HomeController < ApplicationController
  def index
    @featured_products = Product.published.featured.includes(:category, :product_images).limit(8)
    @categories = Category.root_categories.includes(:products)
    @new_arrivals = Product.published.includes(:category, :product_images).order(created_at: :desc).limit(8)
  end
end
