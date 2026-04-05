# Maps Claude's cloth analysis to matching Product records.
#
# Usage:
#   result = LaceMatchService.call(analysis: { recommended_lace_types: [...], ... })
#   result.payload # => { products: [...], summary: "Colors: ivory | Style: ..." }
#
# Query strategy (three-tier fallback — results page is never empty):
#   1. Category match + keyword search (most precise)
#   2. Keyword-only search across all published products
#   3. Featured in-stock products (last resort)
class LaceMatchService < ApplicationService
  MAX_RESULTS = 12

  def initialize(analysis:)
    @analysis = analysis
  end

  def call
    base   = Product.published.in_stock.includes(:category, :product_images)
    cats   = resolve_category_ids
    kwds   = clean_keywords

    products = category_and_keyword_search(base, cats, kwds)
    products = keyword_search(base, kwds)         if products.empty? && kwds.any?
    products = base.featured.limit(MAX_RESULTS)   if products.empty?

    success(products: products.limit(MAX_RESULTS), summary: build_summary)
  end

  private

  def resolve_category_ids
    types = @analysis[:recommended_lace_types].to_a
    return [] if types.empty?
    Category.where(name: types).pluck(:id)
  end

  def clean_keywords
    @analysis[:recommended_lace_keywords].to_a.map(&:strip).reject(&:empty?)
  end

  def category_and_keyword_search(scope, category_ids, keywords)
    scope = scope.where(category_id: category_ids) if category_ids.any?
    scope = keyword_search(scope, keywords)         if keywords.any?
    scope
  end

  def keyword_search(scope, keywords)
    return scope if keywords.empty?

    # Build a safe ILIKE OR-chain across name and description for all keywords
    clauses = keywords.map { "products.name ILIKE ? OR products.description ILIKE ?" }
    binds   = keywords.flat_map do |kw|
      sanitized = "%#{ActiveRecord::Base.sanitize_sql_like(kw)}%"
      [sanitized, sanitized]
    end

    scope.where(clauses.join(" OR "), *binds)
  end

  def build_summary
    parts = []
    colors = @analysis[:dominant_colors].to_a.join(", ")
    parts << "Colors detected: #{colors}"             if colors.present?
    parts << "Style: #{@analysis[:texture_style]}"    if @analysis[:texture_style].present?
    occasions = @analysis[:occasion_tags].to_a.join(", ")
    parts << "Occasion: #{occasions}"                 if occasions.present?
    parts.join("  ·  ")
  end
end
