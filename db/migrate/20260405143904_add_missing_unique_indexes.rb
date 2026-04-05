class AddMissingUniqueIndexes < ActiveRecord::Migration[8.1]
  def change
    add_index :products, :slug, unique: true
    add_index :wishlists, [:user_id, :product_id], unique: true
    add_index :cart_items, [:cart_id, :product_id], unique: true
  end
end
