class CreateProducts < ActiveRecord::Migration[8.1]
  def change
    create_table :products do |t|
      t.string :name
      t.string :slug
      t.text :description
      t.decimal :price, precision: 10, scale: 2, null: false, default: 0
      t.decimal :compare_price, precision: 10, scale: 2
      t.integer :stock_quantity, default: 0
      t.string :sku
      t.references :category, null: false, foreign_key: true
      t.boolean :featured, default: false
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
