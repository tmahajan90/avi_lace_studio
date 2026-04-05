class AddCloudinaryUrlToProducts < ActiveRecord::Migration[8.1]
  def change
    add_column :products, :cloudinary_url, :string
  end
end
