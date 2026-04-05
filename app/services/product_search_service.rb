# Handles product search, filtering, and sorting for the catalog.
# Returns payload with :products (paginated) and :ransack_query (for form helpers).
class ProductSearchService < ApplicationService
  def initialize(params:, scope: Product.published)
    @params = params
    @scope  = scope
  end

  def call
    q       = @scope.includes(:category, :product_images).ransack(@params[:q])
    results = q.result(distinct: true)
    results = apply_category_filter(results)
    results = apply_price_filter(results)
    results = results.page(@params[:page]).per(12)
    success({ products: results, ransack_query: q })
  end

  private

  def apply_category_filter(scope)
    return scope if @params[:category_id].blank?
    scope.where(category_id: @params[:category_id])
  end

  def apply_price_filter(scope)
    scope = scope.where("price >= ?", @params[:min_price]) if @params[:min_price].present?
    scope = scope.where("price <= ?", @params[:max_price]) if @params[:max_price].present?
    scope
  end
end
