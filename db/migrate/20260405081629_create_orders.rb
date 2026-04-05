class CreateOrders < ActiveRecord::Migration[8.1]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.bigint :shipping_address_id
      t.string :order_number
      t.integer :status, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, default: 0
      t.decimal :subtotal, precision: 10, scale: 2, default: 0
      t.decimal :shipping_amount, precision: 10, scale: 2, default: 0
      t.integer :payment_status, default: 0
      t.string :payment_method
      t.string :razorpay_order_id
      t.string :razorpay_payment_id
      t.text :notes

      t.timestamps
    end
  end
end
