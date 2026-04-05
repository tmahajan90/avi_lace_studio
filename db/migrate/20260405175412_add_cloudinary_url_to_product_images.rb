class AddCloudinaryUrlToProductImages < ActiveRecord::Migration[8.1]
  def change
    add_column :product_images, :cloudinary_url, :string
  end
end
