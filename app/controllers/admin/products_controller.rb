module Admin
  class ProductsController < BaseController
    before_action :set_product, only: [:edit, :update, :destroy, :update_stock]

    def index
      @q = Product.includes(:category).ransack(params[:q])
      scope = @q.result(distinct: true)
      if params[:category_id].present?
        cat = Category.find_by(id: params[:category_id])
        ids = cat ? ([cat.id] + cat.subcategories.pluck(:id)) : [params[:category_id]]
        scope = scope.where(category_id: ids)
      end
      scope = scope.where(status: params[:status]) if params[:status].present?
      order = case params[:sort]
        when "name_asc"   then "products.name ASC"
        when "name_desc"  then "products.name DESC"
        when "price_asc"  then "products.price ASC"
        when "price_desc" then "products.price DESC"
        when "stock_asc"  then "products.stock_quantity ASC"
        when "stock_desc" then "products.stock_quantity DESC"
        when "category"   then "categories.name ASC"
        when "oldest"     then "products.created_at ASC"
        else "products.created_at DESC"
      end

      scope = scope.joins(:category) if params[:sort] == "category"
      @products = scope.order(order).page(params[:page]).per(20)
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)
      if @product.save
        redirect_to admin_products_path, notice: "Product created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit; end

    def update
      if @product.update(product_params)
        redirect_to admin_products_path, notice: "Product updated."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @product.destroy
      redirect_to admin_products_path, notice: "Product deleted."
    end

    def update_stock
      qty = params[:stock_quantity].to_i
      if qty >= 0 && @product.update(stock_quantity: qty)
        render json: { stock_quantity: @product.stock_quantity }, status: :ok
      else
        render json: { error: "Invalid quantity" }, status: :unprocessable_entity
      end
    end

    private

    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params.require(:product).permit(:name, :description, :price, :compare_price,
                                      :stock_quantity, :sku, :category_id, :featured,
                                      :status, :main_image, :cloudinary_url)
    end
  end
end
