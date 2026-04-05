module Admin
  class ProductImagesController < BaseController
    before_action :set_product
    before_action :set_image, only: [:destroy]

    def create
      @image = @product.product_images.build(image_params)
      if @image.save
        redirect_to edit_admin_product_path(@product), notice: "Image added."
      else
        redirect_to edit_admin_product_path(@product), alert: "Could not upload image."
      end
    end

    def destroy
      @image.destroy
      redirect_to edit_admin_product_path(@product), notice: "Image removed."
    end

    private

    def set_product
      @product = Product.find(params[:product_id])
    end

    def set_image
      @image = @product.product_images.find(params[:id])
    end

    def image_params
      params.require(:product_image).permit(:image, :position, :alt_text, :cloudinary_url)
    end
  end
end
